{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Functionless.Utils (makeAwsLambdaHandler) where

import qualified Data.ByteString as BS
import qualified Language.Haskell.TH.Lib as TH
import Language.Java (J(..), JNIEnv, JClass, JType(..), reify, reflect)
import Foreign.Ptr

-- https://wiki.haskell.org/Template_Haskell#Wish_list
makeAwsLambdaHandler :: TH.Name -> TH.Q [Dec]
makeAwsLambdaHandler f = do
    g <- TH.mkName "__functionlessWrapper"
    ty <- [t| Ptr JNIEnv -> JClass -> J ('Array ('Prim "byte")) -> J ('Class "com.amazonaws.services.lambda.runtime.Context") -> IO (J ('Array ('Prim "byte"))) |]
    TH.addTopDecls [TH.ForeignD (TH.ExportF TH.CCall "Java_io_tweag_functionless_Entrypoint_nativeHandler" g ty)]
    sequence [TH.sigD g (return ty), TH.funD g (TH.clause [] (TH.normalB [| \_ _ input _ -> reify input >>= reflect . $(varE f) |]) [])]
