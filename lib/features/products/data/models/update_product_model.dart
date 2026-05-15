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

List<dynamic>? _asDynamicList(dynamic value) {
  if (value is! List) return null;
  return value.map(_asDynamic).toList();
}

dynamic _asDynamic(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value.map(_asDynamic).toList();
  }
  if (value is Map) {
    final map = <String, dynamic>{};
    value.forEach((key, nestedValue) {
      map['$key'] = _asDynamic(nestedValue);
    });
    return map;
  }
  if (value is String || value is num || value is bool) {
    return value;
  }
  return value.toString();
}

UpdateProductModel updateProductModelFromJson(str) => UpdateProductModel.fromJson(str);

String updateProductModelToJson(UpdateProductModel data) => json.encode(data.toJson());


UpdateProductModelData updateProductModelDataFromJson(str) => UpdateProductModelData.fromJson(str);

String updateProductModelDataToJson(UpdateProductModelData data) => json.encode(data.toJson());


class UpdateProductModel {
  UpdateProductModelData? data;

  UpdateProductModel({
    this.data,
  });

  factory UpdateProductModel.fromJson(Map<String, dynamic> json) {
    return UpdateProductModel(
      data: json['data'] is Map ? UpdateProductModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class UpdateProductModelData {
  dynamic id;
  dynamic storeId;
  dynamic store;
  dynamic categoryId;
  dynamic category;
  dynamic masterProductId;
  dynamic name;
  dynamic barcode;
  dynamic sourceType;
  dynamic description;
  dynamic price;
  dynamic discountedPrice;
  dynamic image;
  dynamic imageUrl;
  List<dynamic>? images;
  List<dynamic>? imageUrls;
  dynamic stockQuantity;
  dynamic lowStockThreshold;
  dynamic expiresAt;
  dynamic isAvailable;
  dynamic createdAt;
  dynamic updatedAt;

  UpdateProductModelData({
    this.id,
    this.storeId,
    this.store,
    this.categoryId,
    this.category,
    this.masterProductId,
    this.name,
    this.barcode,
    this.sourceType,
    this.description,
    this.price,
    this.discountedPrice,
    this.image,
    this.imageUrl,
    this.images,
    this.imageUrls,
    this.stockQuantity,
    this.lowStockThreshold,
    this.expiresAt,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateProductModelData.fromJson(Map<String, dynamic> json) {
    return UpdateProductModelData(
      id: _asDynamic(json['id']),
      storeId: _asDynamic(json['storeId']),
      store: _asDynamic(json['store']),
      categoryId: _asDynamic(json['categoryId']),
      category: _asDynamic(json['category']),
      masterProductId: _asDynamic(json['masterProductId']),
      name: _asDynamic(json['name']),
      barcode: _asDynamic(json['barcode']),
      sourceType: _asDynamic(json['sourceType']),
      description: _asDynamic(json['description']),
      price: _asDynamic(json['price']),
      discountedPrice: _asDynamic(json['discountedPrice']),
      image: _asDynamic(json['image']),
      imageUrl: _asDynamic(json['imageUrl']),
      images: _asDynamicList(json['images']),
      imageUrls: _asDynamicList(json['imageUrls']),
      stockQuantity: _asDynamic(json['stockQuantity']),
      lowStockThreshold: _asDynamic(json['lowStockThreshold']),
      expiresAt: _asDynamic(json['expiresAt']),
      isAvailable: _asDynamic(json['isAvailable']),
      createdAt: _asDynamic(json['createdAt']),
      updatedAt: _asDynamic(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'store': store,
      'categoryId': categoryId,
      'category': category,
      'masterProductId': masterProductId,
      'name': name,
      'barcode': barcode,
      'sourceType': sourceType,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'image': image,
      'imageUrl': imageUrl,
      'images': images,
      'imageUrls': imageUrls,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'expiresAt': expiresAt,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}