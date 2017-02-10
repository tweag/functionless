package io.tweag.functionless;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.io.*;
import java.nio.file.*;

import java.net.*;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.zip.*;

public class Entrypoint implements RequestHandler<String, String> {
    static {
        try {
            InputStream in =
                Entrypoint.class.getResourceAsStream("/jarify-app.zip");
            File jarifyAppZipFile =
                File.createTempFile("jarify-app-", ".zip");
	    System.out.println(in);
	    System.out.println(jarifyAppZipFile.toPath());
            Files.copy(in, jarifyAppZipFile.toPath(),
                StandardCopyOption.REPLACE_EXISTING);
            in.close();
            try {
              loadApplication(jarifyAppZipFile, "hsapp");
            } finally {
              jarifyAppZipFile.delete();
            }
	    System.out.println("TOTO");
        } catch (Exception e) {
            System.err.println(e);
            throw new ExceptionInInitializerError(e);
        }
    }

    private static void loadApplication(File archive, String appName)
        throws IOException
    {
        // Extract all files from the .zip archive.
        //
        ZipFile zip = new ZipFile(archive);
        String tmpDir = System.getProperty("java.io.tmpdir");
        Path jarifyAppTmpDir =
            Files.createTempDirectory(Paths.get(tmpDir), "jarify-app-");
        ArrayList<Path> pathsList = new ArrayList();
        try {
          for (Enumeration e = zip.entries(); e.hasMoreElements(); ) {
            ZipEntry entry = (ZipEntry)e.nextElement();
            InputStream in = zip.getInputStream(entry);
            Path path = jarifyAppTmpDir.resolve(entry.getName());
            pathsList.add(path);
            Files.copy(in, path);
            in.close();
          }
          zip.close();

          // Dynamically load the app.
          //
          System.load(jarifyAppTmpDir.resolve(appName).toString());
        } finally {
          // Delete the app binary and its libraries, now that they are loaded.
          //
          for (Path p : pathsList)
            p.toFile().delete();
        }
        jarifyAppTmpDir.toFile().delete();
    }

    @Override
    public native String handleRequest(String input, Context context);
}
