
import 'package:flutter/material.dart';
import '../../core/llm_engine.dart';
import '../../core/storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String model = LlmEngine.instance.currentModelId;
  int ctx = 2048;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Model"),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: model,
                items: const [
                  DropdownMenuItem(value: "gemma-2b-it-q4", child: Text("Gemma 2B (Q4) – fast")),
                  DropdownMenuItem(value: "mistral-7b-instruct-q4", child: Text("Mistral 7B Instruct (Q4) – better")),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => model = v);
                  LlmEngine.instance.setModel(v ?? model);
                },
              ),
              const SizedBox(height: 12),
              const Text("Context size"),
              Slider(
                value: ctx.toDouble(),
                min: 512, max: 4096, divisions: 7,
                label: "$ctx",
                onChanged: (v) => setState(() => ctx = v.toInt()),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await LlmEngine.instance.ensureModelDownloaded(model);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Model ready")));
                },
                child: const Text("Download / Verify model"),
              ),
            ]),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Storage"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await Storage.clear();
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cleared")));
                },
                child: const Text("Clear history/cache"),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        const Text("Version 0.1.0", style: TextStyle(color: Color(0xFFB5B5B8))),
      ],
    );
  }
}
