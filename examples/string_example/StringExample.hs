-- | Sample Functionless app.

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module StringExample where

import qualified Data.ByteString as BS
import Language.Java (J(..), JNIEnv, JClass, JType(..), reify, reflect)
import Foreign.Ptr

foreign export ccall "Java_io_tweag_functionless_Entrypoint_nativeHandler" stringExample
  :: Ptr JNIEnv
  -> JClass
  -> J ('Array ('Prim "byte"))
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Array ('Prim "byte")))

stringExample
  :: Ptr JNIEnv
  -> JClass
  -> J ('Array ('Prim "byte"))
  -> J ('Class "com.amazonaws.services.lambda.runtime.Context")
  -> IO (J ('Array ('Prim "byte")))
stringExample _ _ input _ = do
    txt <- reify input
    BS.putStrLn txt
    reflect (BS.concat [txt, ". Hello to you too god sir"])
