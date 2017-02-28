package io.tweag.functionless;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import io.tweag.jarify.HaskellLibraryLoader;

public class Entrypoint implements RequestHandler<Void, Void> {
  private Boolean haskellInitialized = false;

  @Override
  public Void handleRequest(Void input, Context context) {
    if (! haskellInitialized) {
      HaskellLibraryLoader.loadLibraries();
      haskellInitialized = true;
    }
    voidExample();
    return null;
  }

  public static void main(String[] args) {
    HaskellLibraryLoader.loadLibraries();
    voidExample();
  }

  private static native void voidExample();
}
