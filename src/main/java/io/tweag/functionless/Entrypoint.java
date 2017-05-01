package io.tweag.functionless;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import io.tweag.jarify.HaskellLibraryLoader;
import java.io.*;
import org.apache.commons.io.*;

public class Entrypoint implements RequestStreamHandler {
    // XXX: Make this synchronized.
    private static Boolean haskellInitialized = false;

    @Override
    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) throws IOException {
        // Setup the Haskell RTS if needed.
        if (! haskellInitialized) {
            HaskellLibraryLoader.loadLibraries();
            haskellInitialized = true;
        }

        // Empty the InputStream in order to hide the Stream to the native code.
        byte[] input = IOUtils.toByteArray(inputStream);

        outputStream.write(nativeHandler(input, context));
    }

    public static void main(String[] args) throws IOException {
	Entrypoint ep = new Entrypoint();
	ep.handleRequest(System.in, System.out, null);
    }

    private static native byte[] nativeHandler(byte[] input, Context context);
}
