{-# OPTIONS_GHC -Wall #-}

import Control.Monad (join)
import Data.Maybe (maybeToList)
import Text.Read (readMaybe)

parseData :: String -> Maybe (Int, [Double])
parseData x =
    case x' of
        (Just a:b) ->
            case sequenceA b of
                Just b' -> Just (floor a, b')
                _ -> Nothing
        _ -> Nothing
  where
    x' = map readMaybe (words x) :: [Maybe Double]

fmtData :: String -> [(Int, [Double])]
fmtData = join . map (maybeToList . parseData) . lines

main :: IO ()
main = do
    contents <- readFile "input.txt"
    print $ fmtData contents
