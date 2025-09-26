package <SEU_PACOTE>  // ex.: com.josh.aura

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // carrega lib nativa: android/app/src/main/jniLibs/arm64-v8a/libllama.so
    try { System.loadLibrary("llama") } catch (_: Throwable) {}

    val ch = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "llama")
    ch.setMethodCallHandler { call, result ->
      when (call.method) {
        "initModel" -> {
          val path = call.argument<String>("path") ?: return@setMethodCallHandler result.success(false)
          val ctx = call.argument<Int>("ctx") ?: 2048
          val threads = call.argument<Int>("threads") ?: Runtime.getRuntime().availableProcessors()
          result.success(LlamaBridge.init(path, ctx, threads))
        }
        "predict" -> {
          @Suppress("UNCHECKED_CAST")
          val msgs = call.argument<List<Map<String, Any?>>>("messages") ?: emptyList()
          val prompt = PromptBuilder.build(msgs)
          val maxTokens = call.argument<Int>("maxTokens") ?: 256
          val temperature = call.argument<Double>("temperature") ?: 0.7
          val topP = call.argument<Double>("topP") ?: 0.9
          val topK = call.argument<Int>("topK") ?: 40
          val stop = (call.argument<List<String>>("stop") ?: listOf("</s>", "User:")).toTypedArray()
          val out = LlamaBridge.predict(prompt, maxTokens, temperature, topP, topK, stop)
          result.success(out)
        }
        "unload" -> { LlamaBridge.unload(); result.success(true) }
        else -> result.notImplemented()
      }
    }
  }
}

/** Concatena mensagens em prompt simples User/Assistant */
object PromptBuilder {
  fun build(msgs: List<Map<String, Any?>>): String {
    val sb = StringBuilder()
    for (m in msgs) {
      val role = (m["role"] as? String ?: "user").lowercase()
      val content = (m["content"] as? String ?: "")
      if (role == "user") sb.append("User: ").append(content).append('\n')
      else sb.append("Assistant: ").append(content).append('\n')
    }
    sb.append("Assistant:") // sinal para o modelo continuar
    return sb.toString()
  }
}

/** Assinaturas JNI chamadas dentro do libllama.so compilado do llama.cpp */
object LlamaBridge {
  external fun init(modelPath: String, ctx: Int, threads: Int): Boolean
  external fun predict(
    prompt: String,
    maxTokens: Int,
    temperature: Double,
    topP: Double,
    topK: Int,
    stop: Array<String>
  ): String
  external fun unload()
}