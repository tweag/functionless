-- | Sample Functionless app.

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module StringExample where

import qualified Data.ByteString as BS

foreign export ccall "functionless_handler" realHandler
  :: Ptr BS.ByteString
  -> Ptr BS.ByteString

-- | Application specific code.
--   The only part the user actually wants to write.
realHandler :: BS.ByteString -> BS.ByteString
realHandler input = BS.concat [input, ". Hello to you too god sir"]
