import 'dart:convert';

ImportProductsFromMasterModel importProductsFromMasterModelFromJson(
  dynamic str,
) => ImportProductsFromMasterModel.fromJson(
  str is Map<String, dynamic>
      ? str
      : str is Map
      ? Map<String, dynamic>.from(str)
      : <String, dynamic>{},
);

String importProductsFromMasterModelToJson(ImportProductsFromMasterModel data) =>
    json.encode(data.toJson());

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }
  return null;
}

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final text = value.trim();
    return text.isEmpty || text.toLowerCase() == 'null' ? null : text;
  }
  if (value is num || value is bool) return value.toString();
  return null;
}

class ImportProductsFromMasterModel {
  final List<ImportedMasterProduct> data;

  const ImportProductsFromMasterModel({this.data = const []});

  factory ImportProductsFromMasterModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return ImportProductsFromMasterModel(
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map(
                  (item) => ImportedMasterProduct.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((item) => item.toJson()).toList(),
  };
}

class ImportedMasterProduct {
  final int? id;
  final int? categoryId;
  final int? masterProductId;
  final String? name;
  final String? description;
  final String? price;
  final String? discountedPrice;
  final int? stockQuantity;
  final int? lowStockThreshold;
  final String? expiresAt;
  final String? primaryImage;

  const ImportedMasterProduct({
    this.id,
    this.categoryId,
    this.masterProductId,
    this.name,
    this.description,
    this.price,
    this.discountedPrice,
    this.stockQuantity,
    this.lowStockThreshold,
    this.expiresAt,
    this.primaryImage,
  });

  factory ImportedMasterProduct.fromJson(Map<String, dynamic> json) {
    return ImportedMasterProduct(
      id: _asInt(json['id']),
      categoryId: _asInt(json['categoryId']),
      masterProductId: _asInt(json['masterProductId']),
      name: _asString(json['name']),
      description: _asString(json['description']),
      price: _asString(json['price']),
      discountedPrice: _asString(json['discountedPrice']),
      stockQuantity: _asInt(json['stockQuantity']),
      lowStockThreshold: _asInt(json['lowStockThreshold']),
      expiresAt: _asString(json['expiresAt']),
      primaryImage:
          _asString(json['primaryImage']) ?? _asString(json['imageUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'masterProductId': masterProductId,
      'name': name,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'expiresAt': expiresAt,
      'primaryImage': primaryImage,
    };
  }
}
