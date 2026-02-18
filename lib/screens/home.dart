import 'package:curreny/functions/fetchRates.dart';
import 'package:curreny/models/RatesModel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController usdController = TextEditingController();
  final TextEditingController anyController = TextEditingController();

  late Future<RatesModel> result;
  late Future<Map<String, String>> allCurrencies;

  String toCurrency = "INR";
  String fromCurrency = "USD";
  String convertToCurrency = "INR";

  double usdConverted = 0.0;
  double anyConverted = 0.0;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    result = apiService.fetchRates();
    allCurrencies = apiService.fetchCurrencies();
  }

  // 🔹 USD → Any
  void convertUsd(RatesModel ratesModel) {
    double amount = double.tryParse(usdController.text) ?? 0;
    double rate = ratesModel.rates[toCurrency] ?? 1;

    setState(() {
      usdConverted = amount * rate;
    });
  }

  // 🔹 Any → Any
  void convertAny(RatesModel ratesModel) {
    double amount = double.tryParse(anyController.text) ?? 0;

    double fromRate = ratesModel.rates[fromCurrency] ?? 1;
    double toRate = ratesModel.rates[convertToCurrency] ?? 1;

    double usdBase = amount / fromRate;

    setState(() {
      anyConverted = usdBase * toRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              "assets/images/bgg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
            child: FutureBuilder<RatesModel>(
              future: result,
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ratesModel = snapshot.data!;

                return FutureBuilder<Map<String, String>>(
                  future: allCurrencies,
                  builder: (context, currencySnapshot) {

                    if (!currencySnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final currencies = currencySnapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        children: [

                          /// 🔥 USD → Any Currency
                          buildUsdContainer(ratesModel, currencies),

                          const SizedBox(height: 30),

                          /// 🔥 Any → Any Currency
                          buildAnyContainer(ratesModel, currencies),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUsdContainer(RatesModel ratesModel, Map<String, String> currencies) {
    return buildCard(
      title: "USD to Any Currency",
      child: Column(
        children: [
          TextField(
            controller: usdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter USD Amount",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          DropdownButton<String>(
            value: toCurrency,
            isExpanded: true,
            items: currencies.keys.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text("$currency - ${currencies[currency]}"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => toCurrency = value!);
            },
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () => convertUsd(ratesModel),
            child: const Text("Convert"),
          ),

          const SizedBox(height: 10),

          Text(
            "$usdConverted $toCurrency",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildAnyContainer(RatesModel ratesModel, Map<String, String> currencies) {
    return buildCard(
      title: "Any Currency to Any Currency",
      child: Column(
        children: [
          TextField(
            controller: anyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter Amount",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          DropdownButton<String>(
            value: fromCurrency,
            isExpanded: true,
            items: currencies.keys.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text("$currency - ${currencies[currency]}"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => fromCurrency = value!);
            },
          ),

          const SizedBox(height: 10),

          DropdownButton<String>(
            value: convertToCurrency,
            isExpanded: true,
            items: currencies.keys.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text("$currency - ${currencies[currency]}"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => convertToCurrency = value!);
            },
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () => convertAny(ratesModel),
            child: const Text("Convert"),
          ),

          const SizedBox(height: 10),

          Text(
            "$anyConverted $convertToCurrency",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
