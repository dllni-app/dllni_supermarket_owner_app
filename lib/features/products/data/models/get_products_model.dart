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

  GetProductsModelDataItem({
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

  factory GetProductsModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetProductsModelDataItem(
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