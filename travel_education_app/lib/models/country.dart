class Country {
  final String name;
  final String capital;
  final String region;
  final int population;
  final String flagUrl;
  final String code;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
    required this.flagUrl,
    required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final name = (json['name']?['common'] ?? 'Unknown').toString();
    String capital = 'Noma’lum';
    final capitalData = json['capital'];
    if (capitalData is List && capitalData.isNotEmpty) {
      capital = capitalData.first.toString();
    }
    final region = (json['region'] ?? 'Noma’lum').toString();
    final flagUrl = (json['flags']?['png'] ?? '').toString();
    final code = (json['cca3'] ?? name).toString();
    int population = 0;
    final pop = json['population'];
    if (pop is int) population = pop;
    return Country(
      name: name,
      capital: capital,
      region: region,
      population: population,
      flagUrl: flagUrl,
      code: code,
    );
  }
}
