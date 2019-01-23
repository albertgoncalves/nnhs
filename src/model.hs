{-# OPTIONS_GHC -Wall #-}

module Model where

import Math
import Numeric.LinearAlgebra
import Propagate

initModel ::
       Seed
    -> Int
    -> Int
    -> Int
    -> (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
initModel a nInput nHidden nOutput = (w1, w2, b1, b2)
  where
    w1 = initWeights a nInput nHidden
    w2 = initWeights (a + 1) nHidden nOutput
    b1 = initZeros nHidden
    b2 = initZeros nOutput

initWeights :: Seed -> Int -> Int -> Matrix Double
initWeights seed r c = m / sqrt (fromIntegral r)
  where
    m = uniformSample seed r $ replicate c (-1.0, 1.0)

initZeros :: Int -> Matrix Double
initZeros n = (1 >< n) [0.0,0.0 ..]

trainModel ::
       Int
    -> (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
    -> Matrix Double
    -> [Int]
    -> Double
    -> Double
    -> (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
trainModel n model trainX trainY regLambda epsilon
    | n > 0 = trainModel (n - 1) model' trainX trainY regLambda epsilon
    | otherwise = model'
  where
    fwdProp' = fwdProp model trainX
    model' = backProp model trainX trainY fwdProp' regLambda epsilon

predict ::
       (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
    -> Matrix Double
    -> [Int]
predict model testX = predictY
  where
    (probs, _) = fwdProp model testX
    predictY = rowMax probs
