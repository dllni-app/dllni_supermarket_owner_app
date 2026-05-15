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

bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) {
    if (value == 1) return true;
    if (value == 0) return false;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

GetLowStockModel getLowStockModelFromJson(str) => GetLowStockModel.fromJson(str);

String getLowStockModelToJson(GetLowStockModel data) => json.encode(data.toJson());


GetLowStockModelData getLowStockModelDataFromJson(str) => GetLowStockModelData.fromJson(str);

String getLowStockModelDataToJson(GetLowStockModelData data) => json.encode(data.toJson());

List<GetLowStockModelDataItem>? _asLowStockProductList(dynamic value) {
  if (value is! List) return null;
  return value
      .map((e) {
        if (e is! Map) return null;
        return GetLowStockModelDataItem.fromJson(
          Map<String, dynamic>.from(e),
        );
      })
      .whereType<GetLowStockModelDataItem>()
      .toList();
}

class GetLowStockModel {
  bool? success;
  GetLowStockModelData? data;

  GetLowStockModel({
    this.success,
    this.data,
  });

  factory GetLowStockModel.fromJson(Map<String, dynamic> json) {
    return GetLowStockModel(
      success: _asBool(json['success']),
      data: json['data'] is Map ? GetLowStockModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class GetLowStockModelDataItem {
  int? productId;
  String? productName;
  int? currentStock;
  int? threshold;
  String? category;
  String? barcode;

  GetLowStockModelDataItem({
    this.productId,
    this.productName,
    this.currentStock,
    this.threshold,
    this.category,
    this.barcode,
  });

  factory GetLowStockModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetLowStockModelDataItem(
      productId: _asInt(json['product_id']),
      productName: _asString(json['product_name']),
      currentStock: _asInt(json['current_stock']),
      threshold: _asInt(json['threshold']),
      category: _asString(json['category']),
      barcode: _asString(json['barcode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'current_stock': currentStock,
      'threshold': threshold,
      'category': category,
      'barcode': barcode,
    };
  }
}

class GetLowStockModelData {
  List<GetLowStockModelDataItem>? products;
  int? total;

  GetLowStockModelData({
    this.products,
    this.total,
  });

  factory GetLowStockModelData.fromJson(Map<String, dynamic> json) {
    return GetLowStockModelData(
      products: _asLowStockProductList(json['products']),
      total: _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products?.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}