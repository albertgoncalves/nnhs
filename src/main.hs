{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.List (nub)
import Display
import Model
import Numeric.LinearAlgebra (fromLists)
import Prelude hiding ((<>))

testData :: [(Int, [Double])]
testData =
    [ (1, [-0.61633766, 1.6125289])
    , (0, [-2.89740583, -2.1904506])
    , (1, [-0.89653851, 1.79731619])
    , (0, [-0.12136408, -0.51221628])
    , (1, [0.46247358, 1.65605262])
    , (0, [-3.98996527, -0.31745337])
    , (0, [0.69448021, -0.94300908])
    ]

main :: IO ()
main = do
    let (train, test) = splitAt 4 testData
    let (trainY, trainX) = unzip train
    let (testY, testX) = unzip test
    let nInput = length $ head trainX
    let nHidden = 5
    let nOutput = length $ nub trainY
    let regLambda = 0.01
    let epsilon = 0.01
    let n = 100
    let s = 101
    let model =
            trainModel
                n
                (initModel s nInput nHidden nOutput)
                (fromLists trainX)
                trainY
                regLambda
                epsilon
    dispList 3 $ model2List model
    let predictY = predict model (fromLists testX)
    mapM_ print [testY, predictY]
