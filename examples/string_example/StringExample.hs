-- | Sample Functionless app.

{-# LANGUAGE DataKinds #-}

module StringExample where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Language.Java (J(..), JType(..), reify, reflect)

foreign export ccall "Java_io_tweag_functionless_Entrypoint_stringExample" stringExample
  :: J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))

foreign export ccall "Java_io_tweag_functionless_Entrypoint_stringExampleNoContext" stringExampleNoContext
  :: J ('Class "java.lang.String")
  -> IO (J ('Class "java.lang.String"))

stringExample
  :: J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))
stringExample x ctx = do
    txt <- reify x
    Text.putStrLn txt
    reflect txt

-- | Used for calling inside a main, as it Context is an abstract class and thus
-- not that easy to create on the spot.
stringExampleNoContext
  :: J ('Class "java.lang.String")
  -> IO (J ('Class "java.lang.String"))
stringExampleNoContext x = do
    txt <- reify x
    Text.putStrLn txt
    reflect txt
