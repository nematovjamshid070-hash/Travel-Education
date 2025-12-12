import '../models/tip.dart';
import 'api_client.dart';

class TipsService {
  TipsService(this.client);

  final ApiClient client;

  Future<List<Tip>> fetchTips() async {
    final res = await client.getJson('/tips');

    // Supports:
    // - [ ... ]
    // - { "tips": [ ... ] }
    // - { "data": [ ... ] }
    dynamic list = res;
    if (res is Map) {
      if (res['tips'] is List) list = res['tips'];
      if (res['data'] is List) list = res['data'];
    }

    if (list is List) {
      return list.map((e) => Tip.fromJson(e)).toList();
    }

    return const [];
  }
}
