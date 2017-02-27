package io.tweag.functionless;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import io.tweag.jarify.HaskellLibraryLoader;

public class Entrypoint implements RequestHandler<String, String> {
  private Boolean haskellInitialized = false;

  @Override
  public String handleRequest(String input, Context context) {
    if (! haskellInitialized) {
      HaskellLibraryLoader.loadLibraries();
      haskellInitialized = true;
    }
    return foo(input, context);
  }

    public static void main(String[] args) {
      HaskellLibraryLoader.loadLibraries();
      fooNoContext("hello");
    }

  private static native String foo(String input, Context context);
  private static native String fooNoContext(String input);
}
