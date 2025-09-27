cmake_minimum_required(VERSION 3.22)
project(llama_jni)
set(CMAKE_CXX_STANDARD 17)

# libllama pré-compilada pelo passo anterior (copiada para prebuilt/arm64-v8a)
add_library(llama SHARED IMPORTED)
set_target_properties(llama PROPERTIES
  IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/prebuilt/arm64-v8a/libllama.so)

# nosso bridge JNI
add_library(bridge SHARED bridge.cpp)
target_include_directories(bridge PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(bridge llama log)