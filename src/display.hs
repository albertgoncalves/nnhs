{-# OPTIONS_GHC -Wall #-}

module Display where

import Numeric.LinearAlgebra

model2List ::
       (Matrix Double, Matrix Double, Matrix Double, Matrix Double)
    -> [Matrix Double]
model2List (a, b, c, d) = [a, b, c, d]

dispList :: Int -> [Matrix Double] -> IO ()
dispList = mapM_ . disp

accuracy :: [Int] -> [Int] -> Float
accuracy x y = s / l
  where
    s = fromIntegral $ sum z
    l = fromIntegral $ length z
    z = zipWith f x y
    f :: Int -> Int -> Int
    f a b
        | a == b = 1
        | otherwise = 0
