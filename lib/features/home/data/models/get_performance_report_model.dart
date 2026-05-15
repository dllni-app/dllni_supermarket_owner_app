import 'dart:convert';

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }
  return null;
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

num? _asNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

GetPerformanceReportModel getPerformanceReportModelFromJson(dynamic str) {
  final map = str is Map<String, dynamic>
      ? str
      : Map<String, dynamic>.from(str as Map);
  return GetPerformanceReportModel.fromJson(map);
}

String getPerformanceReportModelToJson(GetPerformanceReportModel data) =>
    json.encode(data.toJson());

class GetPerformanceReportModel {
  PerformanceReportRange? range;
  PerformanceReportSupermarket? supermarket;
  List<TopProduct> topProducts;
  OffersImpact? offersImpact;
  BestOfferPerformance? bestOfferPerformance;

  GetPerformanceReportModel({
    this.range,
    this.supermarket,
    this.topProducts = const [],
    this.offersImpact,
    this.bestOfferPerformance,
  });

  factory GetPerformanceReportModel.fromJson(Map<String, dynamic> json) {
    final raw = json['topProducts'];
    final list = <TopProduct>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) {
          list.add(TopProduct.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return GetPerformanceReportModel(
      range: json['range'] is Map
          ? PerformanceReportRange.fromJson(
              Map<String, dynamic>.from(json['range'] as Map),
            )
          : null,
      supermarket: json['supermarket'] is Map
          ? PerformanceReportSupermarket.fromJson(
              Map<String, dynamic>.from(json['supermarket'] as Map),
            )
          : null,
      topProducts: list,
      offersImpact: json['offersImpact'] is Map
          ? OffersImpact.fromJson(
              Map<String, dynamic>.from(json['offersImpact'] as Map),
            )
          : null,
      bestOfferPerformance: json['bestOfferPerformance'] == null
          ? null
          : (json['bestOfferPerformance'] is Map
                ? BestOfferPerformance.fromJson(
                    Map<String, dynamic>.from(
                      json['bestOfferPerformance'] as Map,
                    ),
                  )
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range?.toJson(),
      'supermarket': supermarket?.toJson(),
      'topProducts': topProducts.map((e) => e.toJson()).toList(),
      'offersImpact': offersImpact?.toJson(),
      'bestOfferPerformance': bestOfferPerformance?.toJson(),
    };
  }
}

class PerformanceReportRange {
  String? key;
  String? from;
  String? to;

  PerformanceReportRange({this.key, this.from, this.to});

  factory PerformanceReportRange.fromJson(Map<String, dynamic> json) {
    return PerformanceReportRange(
      key: _asString(json['key']),
      from: _asString(json['from']),
      to: _asString(json['to']),
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'from': from, 'to': to};
}

class PerformanceReportSupermarket {
  int? id;
  String? name;

  PerformanceReportSupermarket({this.id, this.name});

  factory PerformanceReportSupermarket.fromJson(Map<String, dynamic> json) {
    return PerformanceReportSupermarket(
      id: _asInt(json['id']),
      name: _asString(json['name']),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class TopProduct {
  int? productId;
  String? name;
  int? quantity;
  num? revenue;

  TopProduct({this.productId, this.name, this.quantity, this.revenue});

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productId: _asInt(json['productId']),
      name: _asString(json['name']),
      quantity: _asInt(json['quantity']),
      revenue: _asNum(json['revenue']),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'quantity': quantity,
    'revenue': revenue,
  };
}

class OffersImpact {
  int? ordersUsedOffers;
  double? utilizationRatePercent;
  num? offersRevenue;
  int? discountedOrdersCount;
  double? conversionRatePercent;
  num? discountedRevenue;
  num? totalSavings;

  OffersImpact({
    this.ordersUsedOffers,
    this.utilizationRatePercent,
    this.offersRevenue,
    this.discountedOrdersCount,
    this.conversionRatePercent,
    this.discountedRevenue,
    this.totalSavings,
  });

  factory OffersImpact.fromJson(Map<String, dynamic> json) {
    return OffersImpact(
      ordersUsedOffers: _asInt(json['ordersUsedOffers']),
      utilizationRatePercent: _asDouble(json['utilizationRatePercent']),
      offersRevenue: _asNum(json['offersRevenue']),
      discountedOrdersCount: _asInt(json['discountedOrdersCount']),
      conversionRatePercent: _asDouble(json['conversionRatePercent']),
      discountedRevenue: _asNum(json['discountedRevenue']),
      totalSavings: _asNum(json['totalSavings']),
    );
  }

  Map<String, dynamic> toJson() => {
    'ordersUsedOffers': ordersUsedOffers,
    'utilizationRatePercent': utilizationRatePercent,
    'offersRevenue': offersRevenue,
    'discountedOrdersCount': discountedOrdersCount,
    'conversionRatePercent': conversionRatePercent,
    'discountedRevenue': discountedRevenue,
    'totalSavings': totalSavings,
  };
}

class BestOfferPerformance {
  int? offerId;
  String? name;
  String? offerType;
  num? discountValue;
  num? discountPercent;
  int? usesCount;
  num? revenue;
  num? totalSavings;

  BestOfferPerformance({
    this.offerId,
    this.name,
    this.offerType,
    this.discountValue,
    this.discountPercent,
    this.usesCount,
    this.revenue,
    this.totalSavings,
  });

  factory BestOfferPerformance.fromJson(Map<String, dynamic> json) {
    return BestOfferPerformance(
      offerId: _asInt(json['offerId']),
      name: _asString(json['name']),
      offerType: _asString(json['offerType']),
      discountValue: _asNum(json['discountValue']),
      discountPercent: _asNum(json['discountPercent']),
      usesCount: _asInt(json['usesCount']),
      revenue: _asNum(json['revenue']),
      totalSavings: _asNum(json['totalSavings']),
    );
  }

  Map<String, dynamic> toJson() => {
    'offerId': offerId,
    'name': name,
    'offerType': offerType,
    'discountValue': discountValue,
    'discountPercent': discountPercent,
    'usesCount': usesCount,
    'revenue': revenue,
    'totalSavings': totalSavings,
  };
}
