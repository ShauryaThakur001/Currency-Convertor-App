import 'dart:convert';
import 'package:curreny/functions/currenciesModel.dart';
import 'package:curreny/models/RatesModel.dart';
import 'package:http/http.dart' as http;
import 'package:curreny/utils/key.dart';

class ApiService {

  /// 🔹 Base URL
  static const String _baseUrl = "https://openexchangerates.org/api";

  /// 🔹 Fetch latest exchange rates
  Future<RatesModel> fetchRates() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/latest.json?base=USD&app_id=$key"),
    );

    if (response.statusCode == 200) {
      return RatesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load exchange rates: ${response.statusCode}");
    }
  }

  /// 🔹 Fetch all currency names
  Future<Map<String, String>> fetchCurrencies() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/currencies.json?app_id=$key"),
    );

    if (response.statusCode == 200) {
      return allCurrenciesFromJson(response.body);
    } else {
      throw Exception(
          "Failed to load currencies: ${response.statusCode}");
    }
  }
}
