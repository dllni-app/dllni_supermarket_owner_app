import 'dart:convert';

GetInventorySummaryModel getInventorySummaryModelFromJson(dynamic str) =>
    GetInventorySummaryModel.fromJson(
      str is Map<String, dynamic> ? str : <String, dynamic>{},
    );

String getInventorySummaryModelToJson(GetInventorySummaryModel data) =>
    json.encode(data.toJson());

class GetInventorySummaryModel {
  GetInventorySummaryModel({this.data});

  GetInventorySummaryModelData? data;

  factory GetInventorySummaryModel.fromJson(Map<String, dynamic> json) {
    return GetInventorySummaryModel(
      data: json['data'] is Map
          ? GetInventorySummaryModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'data': data?.toJson()};
}

class GetInventorySummaryModelData {
  GetInventorySummaryModelData({
    this.inventoryValue,
    this.productSkus,
    this.lowStockCount,
  });

  final double? inventoryValue;
  final int? productSkus;
  final int? lowStockCount;

  factory GetInventorySummaryModelData.fromJson(Map<String, dynamic> json) {
    return GetInventorySummaryModelData(
      inventoryValue: (json['inventoryValue'] as num?)?.toDouble(),
      productSkus: (json['productSkus'] as num?)?.toInt(),
      lowStockCount: (json['lowStockCount'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'inventoryValue': inventoryValue,
    'productSkus': productSkus,
    'lowStockCount': lowStockCount,
  };
}
