{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE TemplateHaskell #-}

module Functionless.TH (makeAwsLambdaHandler) where

import Control.Monad ((>=>))
import Foreign.JNI (newLocalRef)
import Foreign.JNI.Types (objectFromPtr, unsafeObjectToPtr)
import Foreign.Ptr (Ptr)
import qualified Language.Haskell.TH as TH
import Language.Java (J(..), JNIEnv, JClass, JType(..), reify, reflect)

newtype AwsLambdaContext = AwsLambdaContext (J ('Class "com.amazonaws.services.lambda.runtime.Context"))

-- https://wiki.haskell.org/Template_Haskell#Wish_list
makeAwsLambdaHandler :: TH.Name -> TH.Q [TH.Dec]
makeAwsLambdaHandler f = do
    let g = TH.mkName "__functionlessWrapper"
    ty <- [t| Ptr JNIEnv -> Ptr JClass -> Ptr (J ('Class "com.amazonaws.services.lambda.runtime.Context")) -> Ptr (J ('Array ('Prim "byte"))) -> IO (Ptr (J ('Array ('Prim "byte")))) |]
    let export =
          TH.ForeignD
            (TH.ExportF
               TH.CCall
                 "Java_io_tweag_functionless_Entrypoint_nativeHandler"
                 g
                 ty)
    (export:) <$>
      [d| __functionlessWrapper :: $(return ty)
          __functionlessWrapper _ _ cxtPtr inputPtr = do
              cxt <- AwsLambdaContext <$> objectFromPtr cxtPtr
              input <- objectFromPtr inputPtr
              jobj <- runHandler cxt input
              -- XXX: current type for deleteGlobalRef makes it unusable. But
              -- it's not strictly required anyways, just an optimization to
              -- release resources earlier.
              -- deleteGlobalRef jobj
              return (unsafeObjectToPtr jobj)
            where
              runHandler
                :: AwsLambdaContext
                -> J ('Array ('Prim "byte"))
                -> IO (J ('Array ('Prim "byte")))
              runHandler cxt =
                reify >=> $(TH.varE f) cxt >=> reflect >=> newLocalRef
        |]
