module Main where

import Paths_functionless
import System.Environment (getArgs)
import System.FilePath ((</>))
import System.Process (callProcess)

main :: IO ()
main = do
    argv <- getArgs
    dir <- getDataDir
    case argv of
      [package] -> callProcess
                     "jarify"
	             [ "--base-jar"
	             , dir </> "build/libs/functionless-all.jar"
	             , package ]
      _ -> fail "Usage: functionless <package>"
