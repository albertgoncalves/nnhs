{-# OPTIONS_GHC -Wall #-}

import Control.Monad (join)
import Data.Maybe (fromMaybe, maybeToList)
import Text.Read (readMaybe)

maybeDouble :: String -> Maybe [Double]
maybeDouble = traverse readMaybe . words

stringToList :: (String -> Maybe a) -> String -> [a]
stringToList f = join . map (maybeToList . f) . lines

parseData :: String -> Maybe (Int, [Double])
parseData x =
    case maybeDouble x of
        Just (a:b) -> Just (floor a, b)
        _ -> Nothing

parseParams :: String -> Maybe (Int, Double, Double, Int, Int)
parseParams x =
    case maybeDouble x of
        Just [a, b, c, d, e] -> Just (floor a, b, c, floor d, floor e)
        _ -> Nothing

defaultParams :: (Int, Double, Double, Int, Int)
defaultParams = (10, 0.01, 0.01, 1000, 1)

main :: IO ()
main = do
    [dataFile, paramsFile] <- words <$> getLine
    print . stringToList parseData =<< readFile dataFile
    print . fromMaybe defaultParams . parseParams =<< readFile paramsFile
