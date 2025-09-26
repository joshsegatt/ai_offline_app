
enum Role { user, assistant }

class Message {
  final Role role;
  final String content;
  final DateTime ts;
  final bool error;
  Message({required this.role, required this.content, required this.ts, this.error=false});

  Map<String, dynamic> toChat() => {
    "role": role == Role.user ? "user" : "assistant",
    "content": content,
  };
}
