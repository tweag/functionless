-- | Sample Functionless app.

{-# LANGUAGE DataKinds #-}

module StringExample where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Language.Java (J(..), JType(..), reify, reflect)

foreign export ccall "Java_io_tweag_functionless_Entrypoint_foo" fooWrapped
  :: J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))

foreign export ccall "Java_io_tweag_functionless_Entrypoint_fooNoContext" fooNoContextWrapped
  :: J ('Class "java.lang.String")
  -> IO (J ('Class "java.lang.String"))

fooWrapped
  :: J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))
fooWrapped x ctx = do
    txt <- reify x
    Text.putStrLn txt
    reflect txt

fooNoContextWrapped
  :: J ('Class "java.lang.String")
  -> IO (J ('Class "java.lang.String"))
fooNoContextWrapped x = do
    txt <- reify x
    Text.putStrLn txt
    reflect txt
