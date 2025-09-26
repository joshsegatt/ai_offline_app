
import 'package:flutter/material.dart';
import '../../core/storage.dart';
import '../../core/models.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<List<Message>> convos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    convos = await Storage.loadAllConversations();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (convos.isEmpty) {
      return const Center(child: Text("No conversations yet.", style: TextStyle(color: Color(0xFFB5B5B8))));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: convos.length,
      itemBuilder: (context, i) {
        final c = convos[i];
        final title = c.isNotEmpty ? (c.first.content.length > 32 ? c.first.content.substring(0, 32) + "…" : c.first.content) : "Conversation";
        final date = c.isNotEmpty ? c.first.ts.toIso8601String() : "";
        return Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(date, style: Theme.of(context).textTheme.bodySmall),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await Storage.deleteConversation(i);
                _load();
              },
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => _ConversationView(messages: c),
            )),
          ),
        );
      },
    );
  }
}

class _ConversationView extends StatelessWidget {
  final List<Message> messages;
  const _ConversationView({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversation")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(messages[i].role.name.toUpperCase()),
          subtitle: Text(messages[i].content),
        ),
      ),
    );
  }
}
