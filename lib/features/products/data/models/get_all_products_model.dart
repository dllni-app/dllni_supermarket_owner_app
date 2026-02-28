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

GetAllProductsModel getAllProductsModelFromJson(str) => GetAllProductsModel.fromJson(str);

String getAllProductsModelToJson(GetAllProductsModel data) => json.encode(data.toJson());


GetAllProductsModelMeta getAllProductsModelMetaFromJson(str) => GetAllProductsModelMeta.fromJson(str);

String getAllProductsModelMetaToJson(GetAllProductsModelMeta data) => json.encode(data.toJson());


GetAllProductsModelMetaLinksItem getAllProductsModelMetaLinksItemFromJson(str) => GetAllProductsModelMetaLinksItem.fromJson(str);

String getAllProductsModelMetaLinksItemToJson(GetAllProductsModelMetaLinksItem data) => json.encode(data.toJson());


GetAllProductsModelLinks getAllProductsModelLinksFromJson(str) => GetAllProductsModelLinks.fromJson(str);

String getAllProductsModelLinksToJson(GetAllProductsModelLinks data) => json.encode(data.toJson());


GetAllProductsModelDataItem getAllProductsModelDataItemFromJson(str) => GetAllProductsModelDataItem.fromJson(str);

String getAllProductsModelDataItemToJson(GetAllProductsModelDataItem data) => json.encode(data.toJson());


class GetAllProductsModel {
  List<GetAllProductsModelDataItem>? data;
  GetAllProductsModelLinks? links;
  GetAllProductsModelMeta? meta;

  GetAllProductsModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetAllProductsModel.fromJson(Map<String, dynamic> json) {
    return GetAllProductsModel(
      data: json['data'] is List ? (json['data'] as List).whereType<Map>().map((item) => GetAllProductsModelDataItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      links: json['links'] is Map ? GetAllProductsModelLinks.fromJson(Map<String, dynamic>.from(json['links'] as Map)) : null,
      meta: json['meta'] is Map ? GetAllProductsModelMeta.fromJson(Map<String, dynamic>.from(json['meta'] as Map)) : null,
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

class GetAllProductsModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetAllProductsModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetAllProductsModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetAllProductsModelMeta.fromJson(Map<String, dynamic> json) {
    return GetAllProductsModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List ? (json['links'] as List).whereType<Map>().map((item) => GetAllProductsModelMetaLinksItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
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

class GetAllProductsModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetAllProductsModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetAllProductsModelMetaLinksItem.fromJson(Map<String, dynamic> json) {
    return GetAllProductsModelMetaLinksItem(
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

class GetAllProductsModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetAllProductsModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetAllProductsModelLinks.fromJson(Map<String, dynamic> json) {
    return GetAllProductsModelLinks(
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

class GetAllProductsModelDataItem {
  int? id;
  int? storeId;
  int? categoryId;
  int? masterProductId;
  String? name;
  dynamic barcode;
  String? sourceType;
  dynamic description;
  String? price;
  String? discountedPrice;
  int? stockQuantity;
  int? lowStockThreshold;
  dynamic expiresAt;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  GetAllProductsModelDataItem({
    this.id,
    this.storeId,
    this.categoryId,
    this.masterProductId,
    this.name,
    this.barcode,
    this.sourceType,
    this.description,
    this.price,
    this.discountedPrice,
    this.stockQuantity,
    this.lowStockThreshold,
    this.expiresAt,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory GetAllProductsModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetAllProductsModelDataItem(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      categoryId: _asInt(json['categoryId']),
      masterProductId: _asInt(json['masterProductId']),
      name: _asString(json['name']),
      barcode: _asDynamic(json['barcode']),
      sourceType: _asString(json['sourceType']),
      description: _asDynamic(json['description']),
      price: _asString(json['price']),
      discountedPrice: _asString(json['discountedPrice']),
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
      'categoryId': categoryId,
      'masterProductId': masterProductId,
      'name': name,
      'barcode': barcode,
      'sourceType': sourceType,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'expiresAt': expiresAt,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}