main = do
	print "coucou"

eJNI = do
  [path] <- getArgs
  dlopen path

foreign export
