import 'dart:convert';

LowStockModel lowStockModelFromJson(dynamic str) => LowStockModel.fromJson(str);

String lowStockModelToJson(LowStockModel data) => json.encode(data.toJson());

class LowStockModel {
  final bool? success;
  final LowStockData? data;

  LowStockModel({this.success, this.data});

  factory LowStockModel.fromJson(Map<String, dynamic> json) {
    return LowStockModel(
      success: json['success'] as bool?,
      data: json['data'] is Map ? LowStockData.fromJson(Map<String, dynamic>.from(json['data'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class LowStockData {
  final List<LowStockProduct> products;
  final num? total;

  LowStockData({this.products = const [], this.total});

  factory LowStockData.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'];
    return LowStockData(
      products: productsJson is List
          ? productsJson
              .whereType<Map>()
              .map((item) => LowStockProduct.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      total: json['total'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}

class LowStockProduct {
  final int? productId;
  final String? productName;
  final int? currentStock;
  final int? threshold;
  final String? category;
  final String? barcode;

  LowStockProduct({
    this.productId,
    this.productName,
    this.currentStock,
    this.threshold,
    this.category,
    this.barcode,
  });

  factory LowStockProduct.fromJson(Map<String, dynamic> json) {
    return LowStockProduct(
      productId: json['product_id'] as int?,
      productName: json['product_name']?.toString(),
      currentStock: json['current_stock'] as int?,
      threshold: json['threshold'] as int?,
      category: json['category']?.toString(),
      barcode: json['barcode']?.toString(),
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
