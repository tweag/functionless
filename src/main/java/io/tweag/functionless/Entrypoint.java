package io.tweag.functionless;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import org.apache.commons.io.*;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.lambda.runtime.Context;

import io.tweag.jarify.HaskellLibraryLoader;

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

	// TODO:: use stdin and stdout as streams here.
	public static void main(String[] args) throws IOException {
		Entrypoint ep = new Entrypoint();
		ByteArrayInputStream in = new ByteArrayInputStream("Dummy log".getBytes());
		// Dummy OutputStream that does absolutely nothing.
		OutputStream out = new OutputStream() { @Override public void write(int b) { } };
		ep.handleRequest(in, out, null);
	}

	private static native byte[] nativeHandler(byte[] input, Context context);
}
