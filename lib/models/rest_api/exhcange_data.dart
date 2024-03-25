class CoinData {
  late final String name;
  final double price;
  final double volume24h;
  final DateTime timestamp;

  CoinData({
    required this.name,
    required this.price,
    required this.volume24h,
    required this.timestamp,
  });

  String getName() {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  factory CoinData.fromJson(Map<String, dynamic> json) {
    final double price = json['price'].toDouble();
    final double volume24h = json['volume_24h'].toDouble();
    final timestamp = DateTime.parse(json['timestamp']);

    return CoinData(
      name: json['name'],
      price: price,
      volume24h: volume24h,
      timestamp: timestamp,
    );
  }
}

class CoinDataParser {
  final Map<String, dynamic> jsonData;

  CoinDataParser(this.jsonData);

  List<CoinData> parse() {
    final List<CoinData> coins = [];

    for (final exchange in jsonData.keys) {
      // Extract the first item in each exchange array and add the exchange name as the 'name'.
      final data = jsonData[exchange][0];
      final coinData = CoinData.fromJson({
        ...data,
        'name': exchange, // Set the exchange name as the 'name'.
      });
      coins.add(coinData);
    }

    return coins;
  }
}
