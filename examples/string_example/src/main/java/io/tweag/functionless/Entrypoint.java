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
    return stringExample(input, context);
  }

  public static void main(String[] args) {
    HaskellLibraryLoader.loadLibraries();
    stringExampleNoContext("Hello");
  }

  private static native String stringExample(String input, Context context);
  private static native String stringExampleNoContext(String input);
}
