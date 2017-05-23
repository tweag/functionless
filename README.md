# Functionless

Functionless is a tool that allows you to use Haskell functions as `lamba`s on
AWS Lambda.

It provides:

- Packaging into a `.jar` executable on AWS lambda
- A template Haskell function `makeAwsLambdaHandler` that creates the appropriate JNI bindings and FFI.
- A `.jar` local executable that uses `stdin` and `stdout` for local testing.

## How to use it

### Your program

#### Build options

`functionless` requires a few things from your build options:

- Your Haskell code needs to have an executable target in cabal.
  This target must have the following options:

```
  ghc-options: -dynamic -threaded -Wall
  ld-options: -pie
```

- Your Haskell library will need `functionless` and `bytestring` in its
 `build-depends`.

#### Your lambda

Your lambda handler will have the following type:

```haskell
realHandler :: a -> BS.ByteString -> IO BS.ByteString
```

The `a` here is for the `Context` of AWS Lambda, which is not currently
supported by `functionless`, but will be if users express such a need.

Inputs and outputs are in the form of `ByteString`s because we use the
[stream API](http://docs.aws.amazon.com/lambda/latest/dg/java-handler-io-type-stream.html)
of AWS Lambda.  
Users will thus have to deserialize their input and serialize their output.

The last part is to use the `Functionless.TH.makeAwsLambdaHandler` template
Haskell function on your handler function like this:

```haskell
makeAwsLambdaHandler 'realHandler
```

This is used to do the proper type conversions from Java, and generate the
appropriate JNI bindings for your function to be found.

### Package the program

In order to package your program into a usable `.jar`, simply call
`functionless` on your executable target:

```
stack --nix exec -- functionless your-exe
```

One of the reasons you needed an executable is for easily finding your
binary, this is used by `functionless` in order to find the package.

The previous command will generate the `your-exe.jar`, `.jar` that you can
then upload on the AWS console.

### Local testing

`functionless` also provides an easy way to test locally.

If you launch your executable on your machine using:

```
java -jar your-exe.jar
```

Your handler, will be called on your machine and will use `stdin` as its
input stream, and `stdout` as is output stream. This avoids going back
and forth to the AWS console to test your program.

## Road ahead

### User side

- We would like to add support for operations on the `Context` mentionned
  above.
- We would like to get rid of the need for having an executable at all, this
  means:
    - Getting rid of the `-pie` in `ld-options`
    - Finding an other way than using the executable to get the Haskell RTS

### Library side

- We would like to upload the `HaskellLibraryLoader` to maven, so that we
  don't copy it from `jarify`. 
