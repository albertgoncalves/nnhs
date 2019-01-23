{-# OPTIONS_GHC -Wall #-}

module Propagate where

import Math (sumCols, sumRows)
import Numeric.LinearAlgebra
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
    -> [Int]
    -> (Matrix Double, Matrix Double)
    -> Double
    -> Double
    -> (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
backProp (w1, w2, b1, b2) trainX trainY (probs, a1) regLambda epsilon = model
  where
    delta3 = correction probs trainY
    dw2 = tr a1 <> delta3
    db2 = sumCols delta3
    delta2 = (delta3 <> tr w2) * (1 - (a1 ** 2))
    dw1 = tr trainX <> delta2
    db1 = sumCols delta2
    fEpsilon = nudge (-epsilon)
    fLambda = nudge regLambda
    dw2' = fLambda dw2 w2
    dw1' = fLambda dw1 w1
    w1' = fEpsilon w1 dw1'
    w2' = fEpsilon w2 dw2'
    b1' = fEpsilon b1 db1
    b2' = fEpsilon b2 db2
    model = (w1', w2', b1', b2')

correction :: Matrix Double -> [Int] -> Matrix Double
correction p y = p + fromLists (map mask y)
  where
    mask 0 = [-1.0, 0.0]
    mask _ = [0.0, -1.0]

nudge :: Double -> Matrix Double -> Matrix Double -> Matrix Double
nudge constant input delta = input + (delta * constant')
  where
    constant' = (1 >< 1) [constant]
