-- | Sample Functionless app.

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE TemplateHaskell #-}

module StringExample where

import qualified Data.ByteString as BS
import Functionless.Utils (makeAwsLambdaHandler)

-- | Application specific code.
--   The only part the user actually wants to write.
realHandler :: a -> BS.ByteString -> IO BS.ByteString
realHandler _ input = return $ BS.concat ["{\"test\": \"val\"}"]

makeAwsLambdaHandler 'realHandler
