
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class Storage {
  static const _k = "conversations";

  static Future<void> saveConversation(List<Message> msgs) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAllConversations();
    all.add(msgs);
    final encoded = jsonEncode(all.map((conv)=>conv.map((m)=>{
      "r": m.role.index,
      "c": m.content,
      "t": m.ts.millisecondsSinceEpoch,
      "e": m.error,
    }).toList()).toList());
    await prefs.setString(_k, encoded);
  }

  static Future<List<List<Message>>> loadAllConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_k);
    if (raw == null) return [];
    final data = jsonDecode(raw) as List;
    return data.map<List<Message>>((conv) {
      return (conv as List).map<Message>((m) => Message(
        role: Role.values[(m["r"] as int)],
        content: m["c"] as String,
        ts: DateTime.fromMillisecondsSinceEpoch(m["t"] as int),
        error: (m["e"] as bool? ?? false),
      )).toList();
    }).toList();
  }

  static Future<void> deleteConversation(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadAllConversations();
    if (index >= 0 && index < all.length) {
      all.removeAt(index);
      final encoded = jsonEncode(all.map((conv)=>conv.map((m)=>{
        "r": m.role.index,
        "c": m.content,
        "t": m.ts.millisecondsSinceEpoch,
        "e": m.error,
      }).toList()).toList());
      await prefs.setString(_k, encoded);
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_k);
  }
}
