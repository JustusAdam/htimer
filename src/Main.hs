module Main where

import           Control.Concurrent (threadDelay)
import           Control.Monad      (foldM_, forever)
import           System.Environment (getArgs)


loopSteps = [
    (10, 10),
    (5, 5),
    (1, 0)
  ]


seconds :: Int -> Int
seconds = (* 1000000)


mainLoop :: [Int] -> IO()
mainLoop i = forever $ mapM (loopStep "\n\nNEXT\n") i


loopStep :: String -> Int -> IO()
loopStep message i =
  foldM_ loopSubStep i loopSteps >> putStrLn message


loopSubStep :: Int -> (Int, Int) -> IO Int
loopSubStep num (step, lowerBound) = do
  let remainder = mod num step
  waitIf remainder num
  let newVal = num - remainder
  -- putStrLn ("newVal=" ++ show newVal)
  if newVal <= lowerBound then
    return newVal
  else
    mapM_ (waitAndPrint step) (reverse [i * step | i <- [div lowerBound step + 1 ..(div newVal step)]]) >>
    return lowerBound

  where
    waitIf i = if i /= 0 then waitAndPrint i else return.(const ())

    waitAndPrint wait count = print count >> threadDelay (seconds wait)


getMaybe :: Int -> [a] -> Maybe a
getMaybe _ []     = Nothing
getMaybe 0 (x:_)  = Just x
getMaybe i (_:xs) = getMaybe (i - 1) xs


main :: IO ()
main = do
  args <- getArgs
  case args of
    [] ->
      putStrLn "Need arguments"

    l ->
      mainLoop (times l)

    where
      times :: [String] -> [Int]
      times = map read
