{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.List (nub)
import Data.Maybe (fromMaybe)
import Display (dispList, model2List)
import Model (accuracy, initModel, predict, trainModel)
import Numeric.LinearAlgebra (fromLists)
import Parse (defaultParams, parseData, parseParams, stringToList)
import Prelude hiding ((<>))

main :: IO ()
main = do
    [dataFile, paramsFile] <- words <$> getLine
    dataRaw <- readFile dataFile
    params <- readFile paramsFile
    let testData = stringToList parseData dataRaw
    let (nHidden, regLambda, epsilon, n, splitIndex, seed) =
            fromMaybe defaultParams $ parseParams params :: ( Int
                                                            , Double
                                                            , Double
                                                            , Int
                                                            , Int
                                                            , Int)
    let (train, test) = splitAt splitIndex testData
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
