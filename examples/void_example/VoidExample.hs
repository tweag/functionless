-- | Sample Functionless app without arguments.

{-# LANGUAGE DataKinds #-}

module VoidExample where

import Language.Java (J(..), JType(..), reify, reflect)

foreign export ccall "Java_io_tweag_functionless_Entrypoint_voidExample" voidExample
  :: J ('Class "java.lang.Void")
  -> IO (J ('Class "java.lang.Void"))

voidExample
  :: J ('Class "java.lang.Void")
  -> IO (J ('Class "java.lang.Void"))
voidExample v = do
    print "Hello there"
    return v
