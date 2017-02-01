package io.tweag.jarify;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class JarifyMain extends JarifyBase implements RequestHandler<String, String> {
    private static native void invokeMain(String[] args);
    @Override
    public String handleRequest(String input, Context context) {
      System.out.println("launching the binary");
      String[] ar;
      ar = new String[1];
      ar[0] = input;
      invokeMain(ar);
      System.out.println("finished executing the binary");
      return input;
    }
}
