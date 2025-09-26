import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  // Troque pelo seu Worker quando estiver pronto.
  static const String base = String.fromEnvironment('AURA_API_BASE',
      defaultValue: 'https://<SEU_SUBDOMINIO>.workers.dev');

  static Future<List<Map<String, String>>> webSearch(String query) async {
    final r = await http.post(Uri.parse('$base/api/search'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'q': query}));
    if (r.statusCode != 200) return [];
    final data = jsonDecode(r.body);
    // Esperado: [{title,url,snippet},...]
    return (data is List)
        ? data.cast<Map>().map((e) => e.cast<String, String>()).toList()
        : [];
  }
}