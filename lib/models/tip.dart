class Tip {
  final String title;
  final String body;

  const Tip({required this.title, required this.body});

  factory Tip.fromJson(dynamic json) {
    // Supports multiple backend shapes:
    // 1) { "title": "...", "body": "..." }
    // 2) { "tip": "..." }
    // 3) "..." (string)
    if (json is String) {
      return Tip(title: 'Tip', body: json);
    }
    if (json is Map<String, dynamic>) {
      final title = (json['title'] ?? json['name'] ?? 'Tip').toString();
      final body = (json['body'] ?? json['text'] ?? json['tip'] ?? '').toString();
      return Tip(title: title, body: body.isEmpty ? title : body);
    }
    return Tip(title: 'Tip', body: json.toString());
  }
}
