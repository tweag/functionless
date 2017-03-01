#include <jni.h>

extern jobject string_example(jobject input, jobject context);

JNIEXPORT jobject JNICALL Java_io_tweag_functionless_Entrypoint_stringExample
(
  JNIEnv * env,
  jclass klass,
  jobject input,
  jobject context
) {
  return string_example(input, context);
}
