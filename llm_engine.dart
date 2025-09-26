
/// Placeholder for local LLM engine binding.
/// Wire up llama.cpp-android or MLC runtime here.
/// Current implementation returns a canned response to let the UI run.

class LlmEngine {
  LlmEngine._();
  static final instance = LlmEngine._();

  String currentModelId = "gemma-2b-it-q4";

  Future<void> ensureModelDownloaded(String modelId) async {
    // TODO: implement actual downloader. For now, pretend it's ready.
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void setModel(String modelId) {
    currentModelId = modelId;
  }

  Future<String> generate(List<Map<String, dynamic>> messages,
      {int maxTokens = 256, double temperature = 0.7, double topP = 0.9, int topK = 40}) async {
    // Stubbed generation: echo last user message transformed.
    await Future.delayed(const Duration(milliseconds: 400));
    final last = messages.isNotEmpty ? (messages.last["content"] as String? ?? "") : "";
    return "Offline stub: $last";
  }
}
