{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.List (nub)
import Numeric.LinearAlgebra
import Prelude hiding ((<>))

data Model =
    Model (Matrix Double)
          (Matrix Double)
          (Matrix Double)
          (Matrix Double)

initWeights :: Seed -> Int -> Int -> Matrix Double
initWeights seed n m = mat / sqrt n'
  where
    mat = uniformSample seed n $ replicate m (-1.0, 1.0)
    n' = fromIntegral n

initZeros :: Int -> Matrix Double
initZeros n = matrix n $ replicate n 0.0

initModel :: Seed -> Int -> Int -> Int -> Model
initModel a nInput nHidden nOutput = Model w1 w2 b1 b2
  where
    w1 = initWeights a nInput nHidden
    w2 = initWeights (a + 1) nHidden nOutput
    b1 = initZeros nHidden
    b2 = initZeros nOutput

mapAxis :: Element t1 => (t2 -> [a]) -> (a -> t1) -> t2 -> Matrix t1
mapAxis a f m = fromLists [map f $ a m]

correctProbs :: Int -> [Double] -> [Double]
correctProbs 0 = zipWith (+) [-1, 0]
correctProbs 1 = zipWith (+) [0, -1]
correctProbs _ = id

fwdProp :: Model -> Matrix Double -> (Matrix Double, Matrix Double)
fwdProp model trainX = (probs, a1)
  where
    Model w1 w2 b1 b2 = model
    a1 = tanh $ (trainX <> w1) + b1
    exp_scr = exp $ (a1 <> w2) + b2
    probs = exp_scr / tr (mapAxis toRows sumElements exp_scr)

backProp ::
       Model
    -> Matrix Double
    -> [Int]
    -> Matrix Double
    -> Matrix Double
    -> Double
    -> Double
    -> Model
backProp model trainX trainY probs a1 regLambda epsilon = model'
  where
    Model w1 w2 b1 b2 = model
    delta3 = fromLists $ zipWith correctProbs trainY (toLists probs)
    dw2 = tr a1 <> delta3
    db2 = mapAxis toColumns sumElements delta3
    delta2 = (delta3 <> tr w2) * (1 - (a1 ** 2))
    dw1 = tr trainX <> delta2
    db1 = mapAxis toColumns sumElements delta2
    dw2' = adjust dw2 regLambda w2
    dw1' = adjust dw1 regLambda w1
    w1' = adjust w1 (-epsilon) dw1'
    w2' = adjust w2 (-epsilon) dw2'
    b1' = adjust b1 (-epsilon) db1
    b2' = adjust b2 (-epsilon) db2
    model' = Model w1' w2' b1' b2'

adjust :: Matrix Double -> Double -> Matrix Double -> Matrix Double
adjust input constant delta = input + (delta * constant')
  where
    constant' = fromLists [[constant]]

train :: Int -> Model -> Matrix Double -> [Int] -> Double -> Double -> Model
train n model trainX trainY regLambda epsilon
    | n > 0 = train (n - 1) model' trainX trainY regLambda epsilon
    | otherwise = model'
  where
    (probs, a1) = fwdProp model trainX
    model' = backProp model trainX trainY probs a1 regLambda epsilon

model2List :: Model -> [Matrix Double]
model2List model = [a, b, c, d]
  where
    Model a b c d = model

dispList :: Int -> [Matrix Double] -> IO ()
dispList = mapM_ . disp

rowMax :: Matrix Double -> [Int]
rowMax x = maxIndex <$> toRows x

main :: IO ()
main = do
    let trainX =
            [ [-0.61633766, 1.6125289]
            , [-2.89740583, -2.1904506]
            , [-0.89653851, 1.79731619]
            ]
    let trainX' = fromLists trainX
    let trainY = [1, 0, 1] :: [Int]
    let testX =
            [ [-0.12136408, -0.51221628]
            , [0.46247358, 1.65605262]
            , [-3.98996527, -0.31745337]
            , [0.69448021, -0.94300908]
            ]
    let testX' = fromLists testX
    let testY = [0, 1, 0, 0] :: [Int]
    let nInput = length $ head trainX
    let nHidden = 10
    let nOutput = length $ nub trainY
    let regLambda = 0.01
    let epsilon = 0.01
    let n = 100
    let model = initModel 100 nInput nHidden nOutput
    let model' = train n model trainX' trainY regLambda epsilon
    dispList 3 $ model2List model'
    let (p, _) = fwdProp model' testX'
    disp 3 p
    mapM_ print [rowMax p, testY]
