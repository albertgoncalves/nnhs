{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.List (nub)
import Data.Maybe (fromMaybe)
import Display (dispList, model2List)
import Model (accuracy, initModel, predict, trainModel)
import Numeric.LinearAlgebra (fromLists)
import Parse (defaultParams, parseData, parseParams, stringToList)
import Prelude hiding ((<>))
import Text.Printf

errorSplit :: Int -> [a] -> ([a], [a])
errorSplit i x
    | length a == 0 = error $ msg "training"
    | length b == 0 = error $ msg "testing"
    | otherwise = (a, b)
  where
    (a, b) = splitAt i x
    msg = printf "Splitting data at %d results in zero %s observations.\n" i

main :: IO ()
main = do
    [dataFile, paramsFile] <- words <$> getLine
    dataRaw <- readFile dataFile
    params <- readFile paramsFile
    let testData = stringToList parseData dataRaw
    let lenData = length testData
    if lenData == 0
        then error $ printf "No data found at '%s'.\n" dataFile
        else printf "%d observations loaded.\n" lenData
    let (nHidden, regLambda, epsilon, n, splitIndex, seed) =
            fromMaybe defaultParams $ parseParams params :: ( Int
                                                            , Double
                                                            , Double
                                                            , Int
                                                            , Int
                                                            , Int)
    if nHidden < 1
        then error $ printf "Number of hidden layers must be greater than 0.\n"
        else printf "Training with %d hidden layers.\n" nHidden
    let (train, test) = errorSplit splitIndex testData
    let (trainY, trainX) = unzip train
    let (testY, testX) = unzip test
    let nInput = length $ head trainX
    let nOutput = length $ nub trainY
    let model =
            trainModel
                n
                (initModel seed nInput nHidden nOutput)
                (fromLists trainX)
                nOutput
                trainY
                regLambda
                epsilon
    dispList 3 $ model2List model
    let predictY = predict model (fromLists testX)
    mapM_ print [testY, predictY]
    print $ accuracy testY predictY
