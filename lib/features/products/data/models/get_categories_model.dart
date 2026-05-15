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

GetCategoriesModel getCategoriesModelFromJson(str) => GetCategoriesModel.fromJson(str);

String getCategoriesModelToJson(GetCategoriesModel data) => json.encode(data.toJson());


GetCategoriesModelMeta getCategoriesModelMetaFromJson(str) => GetCategoriesModelMeta.fromJson(str);

String getCategoriesModelMetaToJson(GetCategoriesModelMeta data) => json.encode(data.toJson());


GetCategoriesModelMetaLinksItem getCategoriesModelMetaLinksItemFromJson(str) => GetCategoriesModelMetaLinksItem.fromJson(str);

String getCategoriesModelMetaLinksItemToJson(GetCategoriesModelMetaLinksItem data) => json.encode(data.toJson());


GetCategoriesModelLinks getCategoriesModelLinksFromJson(str) => GetCategoriesModelLinks.fromJson(str);

String getCategoriesModelLinksToJson(GetCategoriesModelLinks data) => json.encode(data.toJson());


GetCategoriesModelDataItem getCategoriesModelDataItemFromJson(str) => GetCategoriesModelDataItem.fromJson(str);

String getCategoriesModelDataItemToJson(GetCategoriesModelDataItem data) => json.encode(data.toJson());


class GetCategoriesModel {
  List<GetCategoriesModelDataItem>? data;
  GetCategoriesModelLinks? links;
  GetCategoriesModelMeta? meta;

  GetCategoriesModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetCategoriesModel.fromJson(Map<String, dynamic> json) {
    return GetCategoriesModel(
      data: json['data'] is List ? (json['data'] as List).whereType<Map>().map((item) => GetCategoriesModelDataItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      links: json['links'] is Map ? GetCategoriesModelLinks.fromJson(Map<String, dynamic>.from(json['links'] as Map)) : null,
      meta: json['meta'] is Map ? GetCategoriesModelMeta.fromJson(Map<String, dynamic>.from(json['meta'] as Map)) : null,
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

class GetCategoriesModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetCategoriesModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetCategoriesModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetCategoriesModelMeta.fromJson(Map<String, dynamic> json) {
    return GetCategoriesModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List ? (json['links'] as List).whereType<Map>().map((item) => GetCategoriesModelMetaLinksItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
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

class GetCategoriesModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetCategoriesModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetCategoriesModelMetaLinksItem.fromJson(Map<String, dynamic> json) {
    return GetCategoriesModelMetaLinksItem(
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

class GetCategoriesModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetCategoriesModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetCategoriesModelLinks.fromJson(Map<String, dynamic> json) {
    return GetCategoriesModelLinks(
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

class GetCategoriesModelDataItem {
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

  GetCategoriesModelDataItem({
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

  factory GetCategoriesModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetCategoriesModelDataItem(
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