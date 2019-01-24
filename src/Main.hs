{-# OPTIONS_GHC -Wall #-}

module Main where

import Data.List (nub)
import Display (dispList, model2List)
import Model (accuracy, initModel, predict, trainModel)
import Numeric.LinearAlgebra (fromLists)
import Prelude hiding ((<>))

testData :: [(Int, [Double])]
testData =
    [ (1, [-3.17228221, 2.55614791])
    , (0, [-1.86490941, -2.41378509])
    , (0, [0.65785232, -1.97970913])
    , (0, [-1.58813387, -1.35920975])
    , (1, [1.49729559, 0.63067423])
    , (0, [0.90976274, -0.96222905])
    , (1, [-2.14040845, 0.90058051])
    , (0, [-1.40567798, -2.25651843])
    , (0, [-1.33227056, -1.69853093])
    , (1, [1.3125179, -0.2894503])
    , (0, [0.93607314, -0.94499938])
    , (0, [1.00757175, -0.5832139])
    , (0, [-2.21481118, -2.13058627])
    , (0, [0.7355556, -1.36766684])
    , (1, [0.88204473, 0.91692274])
    , (1, [2.05477441, 0.31816612])
    , (1, [-1.8523919, 1.68099916])
    , (1, [1.74228521, 0.36759048])
    , (1, [-2.32972389, 1.6714017])
    , (0, [1.2398368, -0.96678822])
    , (1, [-1.38667072, 1.52127328])
    , (1, [-1.0846961, 0.88220432])
    , (0, [-1.30244042, -1.39568197])
    , (1, [-1.06482136, 1.10544507])
    , (0, [1.21697419, 2.06061532])
    , (0, [-1.3545838, -1.60118928])
    , (1, [1.04001422, 0.86757428])
    , (1, [0.75312182, 1.15313715])
    , (1, [0.69480084, 1.17588368])
    , (0, [-1.10738732, -0.991698])
    ]

main :: IO ()
main = do
    let (train, test) = splitAt 5 testData
    let (trainY, trainX) = unzip train
    let (testY, testX) = unzip test
    let nInput = length $ head trainX
    let nHidden = 10
    let nOutput = length $ nub trainY
    let regLambda = 0.001
    let epsilon = 0.001
    let n = 1000
    let s = 2
    let model =
            trainModel
                n
                (initModel s nInput nHidden nOutput)
                (fromLists trainX)
                nOutput
                trainY
                regLambda
                epsilon
    dispList 3 $ model2List model
    let predictY = predict model (fromLists testX)
    mapM_ print [testY, predictY]
    print $ accuracy testY predictY
