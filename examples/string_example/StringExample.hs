-- | Sample Functionless app.

{-# LANGUAGE DataKinds #-}

module StringExample where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Language.Java (J(..), JType(..), JObject, reify, reflect)
import Foreign.JNI

foreign export ccall "string_example" stringExample
  :: J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))

stringExample
  :: J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))
stringExample input _ = do
    txt <- reify input
    Text.putStrLn txt
    let newText = Text.concat [txt, Text.pack ". Hello to you too god sir"]
    reflect newText
