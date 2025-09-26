
import 'package:flutter/material.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Go Premium")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("Free vs Premium", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text("Free: on-device model only, short answers."),
              Text("Premium: faster responses, larger models, web search."),
            ]),
          )),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Go Premium"),
            ),
          ),
        ]),
      ),
    );
  }
}
