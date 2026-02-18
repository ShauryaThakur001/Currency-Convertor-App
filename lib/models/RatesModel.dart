class RatesModel {
  final String base;
  final int timestamp;
  final Map<String, dynamic> rates;

  RatesModel({
    required this.base,
    required this.timestamp,
    required this.rates,
  });

  factory RatesModel.fromJson(Map<String, dynamic> json) {
    return RatesModel(
      base: json['base'] ?? "",
      timestamp: json['timestamp'] ?? 0,
      rates: json['rates'] ?? {},
    );
  }
}
