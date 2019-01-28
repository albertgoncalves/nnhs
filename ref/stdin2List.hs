{-# OPTIONS_GHC -Wall #-}

import Control.Monad (join, replicateM)
import Data.Maybe (maybeToList)
import Text.Read (readMaybe)

stdin2List :: Read a => IO [Maybe a]
stdin2List = fmap readMaybe . words <$> getLine

readData :: [Maybe Double] -> [Double]
readData = join . map maybeToList

main :: IO ()
main = print =<< replicateM 2 (readData <$> stdin2List)
