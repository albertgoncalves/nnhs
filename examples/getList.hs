{-# OPTIONS_GHC -Wall #-}

import Control.Monad (join)
import Data.Maybe (maybeToList)
import Text.Read (readMaybe)

getList :: Read a => IO [Maybe a]
getList = fmap readMaybe . words <$> getLine

main :: IO ()
main = do
    a <- getList :: IO [Maybe Int]
    mapM_ print $ join $ map maybeToList a
