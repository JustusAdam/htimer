{-# LANGUAGE LambdaCase #-}
module Main (main) where

import           Control.Concurrent (threadDelay)
import           Control.Monad      (foldM_, forever)
import           System.Environment (getArgs)
import           Data.Foldable


loopSteps =
  [ (10, 10)
  , (5, 5)
  , (1, 0)
  ]


seconds :: Int -> Int
seconds = (* 1000000)


mainLoop :: [Int] -> IO ()
mainLoop = forever . mapM (loopStep "\n\nNEXT\n")


loopStep :: String -> Int -> IO ()
loopStep message i =
  foldM_ (uncurry . loopSubStep) i loopSteps >> putStrLn message


loopSubStep :: Int -> Int -> Int -> IO Int
loopSubStep num step lowerBound
  | remainder /= 0 =
    waitAndPrint remainder num >>
    loopSubStep (num - remainder) step lowerBound
  | num <= lowerBound = return lowerBound
  | otherwise =
    traverse_ (waitAndPrint step) steps >>
    return lowerBound
  where
    remainder = mod num step
    steps = reverse $ map (* step) [(lowerBound `div` step) + 1 .. (num `div` step)]

    waitAndPrint wait count = print count >> threadDelay (seconds wait)


main :: IO ()
main =
  getArgs >>= \case
    []  -> putStrLn "Need arguments"
    l   -> mainLoop $ map read l
