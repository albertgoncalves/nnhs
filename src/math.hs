{-# OPTIONS_GHC -Wall #-}

module Math where

import Numeric.LinearAlgebra
import Prelude hiding ((<>))

sumRows :: (Numeric t, Enum t) => Matrix t -> Matrix t
sumRows m = m <> (cols m >< 1) [1,1 ..]

sumCols :: (Numeric t, Enum t) => Matrix t -> Matrix t
sumCols m = (1 >< rows m) [1,1 ..] <> m

rowMax :: (Numeric t, Enum t) => Matrix t -> [Int]
rowMax m = maxIndex <$> toRows m
