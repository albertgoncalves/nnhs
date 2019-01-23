{-# OPTIONS_GHC -Wall #-}

module Display where

import Numeric.LinearAlgebra

model2List ::
       (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
    -> [Matrix Double]
model2List (a, b, c, d) = [a, b, c, d]

dispList :: Int -> [Matrix Double] -> IO ()
dispList = mapM_ . disp
