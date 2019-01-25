{-# OPTIONS_GHC -Wall #-}

import Control.Monad (join)
import Data.Maybe (maybeToList)
import Text.Read (readMaybe)

parseData :: String -> Maybe (Int, [Double])
parseData x =
    case traverse readMaybe $ words x of
        Just (a:b) -> Just (floor a, b)
        _ -> Nothing

fmtData :: String -> [(Int, [Double])]
fmtData = join . map (maybeToList . parseData) . lines

main :: IO ()
main = do
    contents <- readFile "input.txt"
    print $ fmtData contents
