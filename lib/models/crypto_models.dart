// To parse this JSON data, do
//
//     final cryptoModels = cryptoModelsFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'crypto_models.g.dart';

List<CryptoModels> cryptoModelsFromJson(String str) => List<CryptoModels>.from(
  json.decode(str).map((x) => CryptoModels.fromJson(x)),
);

String cryptoModelsToJson(List<CryptoModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CryptoModels {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "symbol")
  String symbol;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "image")
  String image;
  @JsonKey(name: "current_price")
  double currentPrice;
  @JsonKey(name: "market_cap")
  double marketCap;
  @JsonKey(name: "market_cap_rank")
  int marketCapRank;
  @JsonKey(name: "fully_diluted_valuation")
  double fullyDilutedValuation;
  @JsonKey(name: "total_volume")
  int? totalVolume;
  @JsonKey(name: "high_24h")
  double high24H;
  @JsonKey(name: "low_24h")
  double low24H;
  @JsonKey(name: "price_change_24h")
  double priceChange24H;
  @JsonKey(name: "price_change_percentage_24h")
  double priceChangePercentage24H;
  @JsonKey(name: "market_cap_change_24h")
  double marketCapChange24H;
  @JsonKey(name: "market_cap_change_percentage_24h")
  double marketCapChangePercentage24H;
  @JsonKey(name: "circulating_supply")
  double circulatingSupply;
  @JsonKey(name: "total_supply")
  double totalSupply;
  @JsonKey(name: "max_supply")
  double? maxSupply;
  @JsonKey(name: "ath")
  double ath;
  @JsonKey(name: "ath_change_percentage")
  double athChangePercentage;
  @JsonKey(name: "ath_date")
  DateTime athDate;
  @JsonKey(name: "atl")
  double atl;
  @JsonKey(name: "atl_change_percentage")
  double atlChangePercentage;
  @JsonKey(name: "atl_date")
  DateTime atlDate;
  @JsonKey(name: "roi")
  Roi? roi;
  @JsonKey(name: "last_updated")
  DateTime lastUpdated;

  CryptoModels({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24H,
    required this.low24H,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.marketCapChange24H,
    required this.marketCapChangePercentage24H,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.roi,
    required this.lastUpdated,
  });

  factory CryptoModels.fromJson(Map<String, dynamic> json) =>
      _$CryptoModelsFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoModelsToJson(this);
}

@JsonSerializable()
class Roi {
  @JsonKey(name: "times")
  double times;
  @JsonKey(name: "currency")
  String currency;
  @JsonKey(name: "percentage")
  double percentage;

  Roi({required this.times, required this.currency, required this.percentage});

  factory Roi.fromJson(Map<String, dynamic> json) => _$RoiFromJson(json);

  Map<String, dynamic> toJson() => _$RoiToJson(this);
}
