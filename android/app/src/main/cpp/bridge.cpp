#include <jni.h>
#include <string>

// stubs mínimos; depois você ajusta as assinaturas para o seu pacote
extern "C" JNIEXPORT jboolean JNICALL
Java_com_example_app_LlamaBridge_init(JNIEnv*, jclass, jstring, jint, jint) {
  return JNI_TRUE;
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_app_LlamaBridge_predict(JNIEnv* env, jclass,
                                         jstring, jint, jdouble, jdouble, jint, jobjectArray) {
  return env->NewStringUTF("ok");
}

extern "C" JNIEXPORT void JNICALL
Java_com_example_app_LlamaBridge_unload(JNIEnv*, jclass) {}