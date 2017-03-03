-- | Sample Functionless app.

{-# LANGUAGE DataKinds #-}

module StringExample where

import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Language.Java (J(..), JNIEnv, JClass, JType(..), reify, reflect)
import Foreign.Ptr

foreign export ccall "Java_io_tweag_functionless_Entrypoint_stringExample" stringExample
  :: Ptr JNIEnv
  -> JClass
  -> J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))

stringExample
  :: Ptr JNIEnv
  -> JClass
  -> J ('Class "java.lang.String")
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Class "java.lang.String"))
stringExample _ _ input _ = do
    txt <- reify input
    Text.putStrLn txt
    let newText = Text.concat [txt, Text.pack ". Hello to you too god sir"]
    reflect newText
