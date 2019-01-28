{-# OPTIONS_GHC -Wall #-}

module Propagate where

import Math (sumCols, sumRows)
import Numeric.LinearAlgebra (Matrix, (<>), (><), fromLists, tr)
import Prelude hiding ((<>))

fwdProp ::
       (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
    -> Matrix Double
    -> (Matrix Double, Matrix Double)
fwdProp (w1, w2, b1, b2) trainX = (probs, a1)
  where
    a1 = tanh $ (trainX <> w1) + b1
    exp_scr = exp $ (a1 <> w2) + b2
    probs = exp_scr / sumRows exp_scr

backProp ::
       (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
    -> Matrix Double
    -> Int
    -> [Int]
    -> (Matrix Double, Matrix Double)
    -> Double
    -> Double
    -> (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
backProp (w1, w2, b1, b2) trainX nOutput trainY (probs, a1) regLambda epsilon =
    model
  where
    delta3 = correction probs nOutput trainY
    dw2 = tr a1 <> delta3
    db2 = sumCols delta3
    delta2 = (delta3 <> tr w2) * (1 - (a1 ** 2))
    dw1 = tr trainX <> delta2
    db1 = sumCols delta2
    nudgeEpsilon = nudge (-epsilon)
    nudgeLambda = nudge regLambda
    dw2' = nudgeLambda dw2 w2
    dw1' = nudgeLambda dw1 w1
    w1' = nudgeEpsilon w1 dw1'
    w2' = nudgeEpsilon w2 dw2'
    b1' = nudgeEpsilon b1 db1
    b2' = nudgeEpsilon b2 db2
    model = (w1', w2', b1', b2')

correction :: Matrix Double -> Int -> [Int] -> Matrix Double
correction p n y = p + fromLists (map (mask n) y)

mask :: Int -> Int -> [Double]
mask n i = f n (i + 1) []
  where
    f n' i' l
        | n' <= 0 = l
        | i' == n' = f n'' i' (-1.0 : l)
        | otherwise = f n'' i' (0.0 : l)
      where
        n'' = n' - 1

nudge :: Double -> Matrix Double -> Matrix Double -> Matrix Double
nudge constant input delta = input + (delta * constant')
  where
    constant' = (1 >< 1) [constant]
