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

GetProductsModel getProductsModelFromJson(str) => GetProductsModel.fromJson(str);

String getProductsModelToJson(GetProductsModel data) => json.encode(data.toJson());


GetProductsModelMeta getProductsModelMetaFromJson(str) => GetProductsModelMeta.fromJson(str);

String getProductsModelMetaToJson(GetProductsModelMeta data) => json.encode(data.toJson());


GetProductsModelMetaLinksItem getProductsModelMetaLinksItemFromJson(str) => GetProductsModelMetaLinksItem.fromJson(str);

String getProductsModelMetaLinksItemToJson(GetProductsModelMetaLinksItem data) => json.encode(data.toJson());


GetProductsModelLinks getProductsModelLinksFromJson(str) => GetProductsModelLinks.fromJson(str);

String getProductsModelLinksToJson(GetProductsModelLinks data) => json.encode(data.toJson());


GetProductsModelDataItem getProductsModelDataItemFromJson(str) => GetProductsModelDataItem.fromJson(str);

String getProductsModelDataItemToJson(GetProductsModelDataItem data) => json.encode(data.toJson());


GetProductsModelDataItemCategory getProductsModelDataItemCategoryFromJson(str) => GetProductsModelDataItemCategory.fromJson(str);

String getProductsModelDataItemCategoryToJson(GetProductsModelDataItemCategory data) => json.encode(data.toJson());


GetProductsModelDataItemStore getProductsModelDataItemStoreFromJson(str) => GetProductsModelDataItemStore.fromJson(str);

String getProductsModelDataItemStoreToJson(GetProductsModelDataItemStore data) => json.encode(data.toJson());


class GetProductsModel {
  List<GetProductsModelDataItem>? data;
  GetProductsModelLinks? links;
  GetProductsModelMeta? meta;

  GetProductsModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetProductsModel.fromJson(Map<String, dynamic> json) {
    return GetProductsModel(
      data: json['data'] is List ? (json['data'] as List).whereType<Map>().map((item) => GetProductsModelDataItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      links: json['links'] is Map ? GetProductsModelLinks.fromJson(Map<String, dynamic>.from(json['links'] as Map)) : null,
      meta: json['meta'] is Map ? GetProductsModelMeta.fromJson(Map<String, dynamic>.from(json['meta'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
      'links': links?.toJson(),
      'meta': meta?.toJson(),
    };
  }
}

class GetProductsModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetProductsModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetProductsModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetProductsModelMeta.fromJson(Map<String, dynamic> json) {
    return GetProductsModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List ? (json['links'] as List).whereType<Map>().map((item) => GetProductsModelMetaLinksItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      path: _asString(json['path']),
      perPage: _asInt(json['per_page']),
      to: _asInt(json['to']),
      total: _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links?.map((item) => item.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class GetProductsModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetProductsModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetProductsModelMetaLinksItem.fromJson(Map<String, dynamic> json) {
    return GetProductsModelMetaLinksItem(
      url: _asString(json['url']),
      label: _asString(json['label']),
      page: _asInt(json['page']),
      active: _asBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}

class GetProductsModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetProductsModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetProductsModelLinks.fromJson(Map<String, dynamic> json) {
    return GetProductsModelLinks(
      first: _asString(json['first']),
      last: _asString(json['last']),
      prev: _asDynamic(json['prev']),
      next: _asDynamic(json['next']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

class GetProductsModelDataItem {
  int? id;
  // I add this params
  bool isSelected;
  int? storeId;
  GetProductsModelDataItemStore? store;
  int? categoryId;
  GetProductsModelDataItemCategory? category;
  int? masterProductId;
  String? name;
  dynamic barcode;
  String? sourceType;
  dynamic description;
  String? price;
  String? discountedPrice;
  dynamic image;
  dynamic imageUrl;
  List<dynamic>? images;
  List<dynamic>? imageUrls;
  int? stockQuantity;
  int? lowStockThreshold;
  dynamic expiresAt;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  GetProductsModelDataItem({
    this.isSelected = false,
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

  factory GetProductsModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetProductsModelDataItem(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      store: json['store'] is Map ? GetProductsModelDataItemStore.fromJson(Map<String, dynamic>.from(json['store'] as Map)) : null,
      categoryId: _asInt(json['categoryId']),
      category: json['category'] is Map ? GetProductsModelDataItemCategory.fromJson(Map<String, dynamic>.from(json['category'] as Map)) : null,
      masterProductId: _asInt(json['masterProductId']),
      name: _asString(json['name']),
      barcode: _asDynamic(json['barcode']),
      sourceType: _asString(json['sourceType']),
      description: _asDynamic(json['description']),
      price: _asString(json['price']),
      discountedPrice: _asString(json['discountedPrice']),
      image: _asDynamic(json['image']),
      imageUrl: _asDynamic(json['imageUrl']),
      images: _asDynamicList(json['images']),
      imageUrls: _asDynamicList(json['imageUrls']),
      stockQuantity: _asInt(json['stockQuantity']),
      lowStockThreshold: _asInt(json['lowStockThreshold']),
      expiresAt: _asDynamic(json['expiresAt']),
      isAvailable: _asBool(json['isAvailable']),
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

class GetProductsModelDataItemCategory {
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

  GetProductsModelDataItemCategory({
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

  factory GetProductsModelDataItemCategory.fromJson(Map<String, dynamic> json) {
    return GetProductsModelDataItemCategory(
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

class GetProductsModelDataItemStore {
  int? id;
  int? ownerUserId;
  String? name;
  String? slug;
  String? description;
  String? address;
  dynamic city;
  dynamic neighborhood;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  dynamic cover;
  dynamic logo;
  String? averageRating;
  int? totalReviews;
  int? trustScore;
  int? warningCount;
  bool? isActive;
  bool? isFeatured;
  dynamic suspensionUntil;
  String? createdAt;
  String? updatedAt;

  GetProductsModelDataItemStore({
    this.id,
    this.ownerUserId,
    this.name,
    this.slug,
    this.description,
    this.address,
    this.city,
    this.neighborhood,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.cover,
    this.logo,
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

  factory GetProductsModelDataItemStore.fromJson(Map<String, dynamic> json) {
    return GetProductsModelDataItemStore(
      id: _asInt(json['id']),
      ownerUserId: _asInt(json['ownerUserId']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      description: _asString(json['description']),
      address: _asString(json['address']),
      city: _asDynamic(json['city']),
      neighborhood: _asDynamic(json['neighborhood']),
      latitude: _asString(json['latitude']),
      longitude: _asString(json['longitude']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      cover: _asDynamic(json['cover']),
      logo: _asDynamic(json['logo']),
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
      'city': city,
      'neighborhood': neighborhood,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'cover': cover,
      'logo': logo,
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