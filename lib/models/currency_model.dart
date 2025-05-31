class CurrencyModel {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final double exchangeRateToUsd;
  final bool isActive;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.exchangeRateToUsd,
    required this.isActive,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        symbol: json["symbol"],
        exchangeRateToUsd: double.parse(
          double.tryParse(json["exchange_rate_to_usd"]) == null ? "0" : json["exchange_rate_to_usd"],
        ),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "symbol": symbol,
        "exchange_rate_to_usd": exchangeRateToUsd,
        "is_active": isActive,
      };

  @override
  String toString() {
    return "$code";
  }
}
