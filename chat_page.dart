
import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../../core/storage.dart';
import '../../core/llm_engine.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<Message> _messages = [];
  bool _busy = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _busy) return;
    setState(() {
      _messages.add(Message(role: Role.user, content: text, ts: DateTime.now()));
      _busy = true;
      _ctrl.clear();
    });
    await Future.delayed(const Duration(milliseconds: 50));
    _scroll.animateTo(_scroll.position.maxScrollExtent + 120, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);

    try {
      final reply = await LlmEngine.instance.generate(
        _messages.map((m)=>m.toChat()).toList(),
        maxTokens: 256, temperature: 0.7, topP: 0.9, topK: 40,
      );
      setState(() {
        _messages.add(Message(role: Role.assistant, content: reply, ts: DateTime.now()));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(role: Role.assistant, content: "Error: $e", ts: DateTime.now(), error: true));
      });
    } finally {
      setState(() => _busy = false);
      await Storage.saveConversation(_messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _messages.length,
            itemBuilder: (context, i) => _Bubble(msg: _messages[i]),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    minLines: 1, maxLines: 5,
                    decoration: const InputDecoration(hintText: "Type a message"),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _busy ? null : _send,
                  child: const Text("Send"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final Message msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.role == Role.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF131316) : const Color(0xFF0F0F10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1A1A1B)),
        ),
        child: SelectableText(msg.content, style: TextStyle(color: msg.error ? Colors.redAccent : null)),
      ),
    );
  }
}
