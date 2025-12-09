import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1/all';

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final list = data.map((e) => Country.fromJson(e)).toList();
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    }
    throw Exception("Load error");
  }
}
