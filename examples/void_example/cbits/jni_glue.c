#include <jni.h>

extern jobject void_example(jobject input, jobject context);

JNIEXPORT jobject JNICALL Java_io_tweag_functionless_Entrypoint_voidExample
(
  JNIEnv * env,
  jclass klass,
  jobject input,
  jobject context
) {
  return void_example(input, context);
}
