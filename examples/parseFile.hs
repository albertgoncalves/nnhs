{-# OPTIONS_GHC -Wall #-}

import Control.Monad (join)
import Data.Maybe (maybeToList)
import Text.Read (readMaybe)

parseData :: String -> Maybe ([Double], Int)
parseData x =
    case x' of
        [Just a, Just b, Just c] -> Just ([a, b], floor c)
        _ -> Nothing
  where
    x' = map readMaybe (words x) :: [Maybe Double]

fmtData :: String -> [([Double], Int)]
fmtData = join . map (maybeToList . parseData) . lines

main :: IO ()
main = do
    contents <- readFile "input.txt"
    print $ fmtData contents
