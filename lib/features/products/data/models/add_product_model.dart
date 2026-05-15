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

AddProductModel addProductModelFromJson(str) => AddProductModel.fromJson(str);

String addProductModelToJson(AddProductModel data) => json.encode(data.toJson());


AddProductModelData addProductModelDataFromJson(str) => AddProductModelData.fromJson(str);

String addProductModelDataToJson(AddProductModelData data) => json.encode(data.toJson());


AddProductModelDataCategory addProductModelDataCategoryFromJson(str) => AddProductModelDataCategory.fromJson(str);

String addProductModelDataCategoryToJson(AddProductModelDataCategory data) => json.encode(data.toJson());


AddProductModelDataStore addProductModelDataStoreFromJson(str) => AddProductModelDataStore.fromJson(str);

String addProductModelDataStoreToJson(AddProductModelDataStore data) => json.encode(data.toJson());


class AddProductModel {
  AddProductModelData? data;

  AddProductModel({
    this.data,
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      data: json['data'] is Map ? AddProductModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class AddProductModelData {
  int? id;
  int? storeId;
  AddProductModelDataStore? store;
  int? categoryId;
  AddProductModelDataCategory? category;
  dynamic masterProductId;
  String? name;
  String? barcode;
  String? sourceType;
  String? description;
  String? price;
  String? discountedPrice;
  dynamic image;
  dynamic imageUrl;
  List<dynamic>? images;
  List<dynamic>? imageUrls;
  int? stockQuantity;
  int? lowStockThreshold;
  dynamic expiresAt;
  dynamic isAvailable;
  String? createdAt;
  String? updatedAt;

  AddProductModelData({
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

  factory AddProductModelData.fromJson(Map<String, dynamic> json) {
    return AddProductModelData(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      store: json['store'] is Map ? AddProductModelDataStore.fromJson(Map<String, dynamic>.from(json['store'] as Map)) : null,
      categoryId: _asInt(json['categoryId']),
      category: json['category'] is Map ? AddProductModelDataCategory.fromJson(Map<String, dynamic>.from(json['category'] as Map)) : null,
      masterProductId: _asDynamic(json['masterProductId']),
      name: _asString(json['name']),
      barcode: _asString(json['barcode']),
      sourceType: _asString(json['sourceType']),
      description: _asString(json['description']),
      price: _asString(json['price']),
      discountedPrice: _asString(json['discountedPrice']),
      image: _asDynamic(json['image']),
      imageUrl: _asDynamic(json['imageUrl']),
      images: _asDynamicList(json['images']),
      imageUrls: _asDynamicList(json['imageUrls']),
      stockQuantity: _asInt(json['stockQuantity']),
      lowStockThreshold: _asInt(json['lowStockThreshold']),
      expiresAt: _asDynamic(json['expiresAt']),
      isAvailable: _asDynamic(json['isAvailable']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'store': store?.toJson(),
      'categoryId': categoryId,
      'category': category?.toJson(),
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

class AddProductModelDataCategory {
  int? id;
  int? storeId;
  String? name;
  String? slug;
  dynamic description;
  int? sortOrder;
  dynamic imagePath;
  bool? isActive;
  int? productsCount;
  String? createdAt;
  String? updatedAt;

  AddProductModelDataCategory({
    this.id,
    this.storeId,
    this.name,
    this.slug,
    this.description,
    this.sortOrder,
    this.imagePath,
    this.isActive,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory AddProductModelDataCategory.fromJson(Map<String, dynamic> json) {
    return AddProductModelDataCategory(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      description: _asDynamic(json['description']),
      sortOrder: _asInt(json['sortOrder']),
      imagePath: _asDynamic(json['imagePath']),
      isActive: _asBool(json['isActive']),
      productsCount: _asInt(json['productsCount']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'slug': slug,
      'description': description,
      'sortOrder': sortOrder,
      'imagePath': imagePath,
      'isActive': isActive,
      'productsCount': productsCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class AddProductModelDataStore {
  int? id;
  int? ownerUserId;
  String? name;
  String? slug;
  String? description;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  String? averageRating;
  int? totalReviews;
  int? trustScore;
  int? warningCount;
  bool? isActive;
  bool? isFeatured;
  dynamic suspensionUntil;
  String? createdAt;
  String? updatedAt;

  AddProductModelDataStore({
    this.id,
    this.ownerUserId,
    this.name,
    this.slug,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.averageRating,
    this.totalReviews,
    this.trustScore,
    this.warningCount,
    this.isActive,
    this.isFeatured,
    this.suspensionUntil,
    this.createdAt,
    this.updatedAt,
  });

  factory AddProductModelDataStore.fromJson(Map<String, dynamic> json) {
    return AddProductModelDataStore(
      id: _asInt(json['id']),
      ownerUserId: _asInt(json['ownerUserId']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      description: _asString(json['description']),
      address: _asString(json['address']),
      latitude: _asString(json['latitude']),
      longitude: _asString(json['longitude']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      averageRating: _asString(json['averageRating']),
      totalReviews: _asInt(json['totalReviews']),
      trustScore: _asInt(json['trustScore']),
      warningCount: _asInt(json['warningCount']),
      isActive: _asBool(json['isActive']),
      isFeatured: _asBool(json['isFeatured']),
      suspensionUntil: _asDynamic(json['suspensionUntil']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUserId': ownerUserId,
      'name': name,
      'slug': slug,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'trustScore': trustScore,
      'warningCount': warningCount,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'suspensionUntil': suspensionUntil,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}