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

GetOfferCodesModel getOfferCodesModelFromJson(str) => GetOfferCodesModel.fromJson(str);

String getOfferCodesModelToJson(GetOfferCodesModel data) => json.encode(data.toJson());


GetOfferCodesModelMeta getOfferCodesModelMetaFromJson(str) => GetOfferCodesModelMeta.fromJson(str);

String getOfferCodesModelMetaToJson(GetOfferCodesModelMeta data) => json.encode(data.toJson());


GetOfferCodesModelMetaLinksItem getOfferCodesModelMetaLinksItemFromJson(str) => GetOfferCodesModelMetaLinksItem.fromJson(str);

String getOfferCodesModelMetaLinksItemToJson(GetOfferCodesModelMetaLinksItem data) => json.encode(data.toJson());


GetOfferCodesModelLinks getOfferCodesModelLinksFromJson(str) => GetOfferCodesModelLinks.fromJson(str);

String getOfferCodesModelLinksToJson(GetOfferCodesModelLinks data) => json.encode(data.toJson());


GetOfferCodesModelDataItem getOfferCodesModelDataItemFromJson(str) => GetOfferCodesModelDataItem.fromJson(str);

String getOfferCodesModelDataItemToJson(GetOfferCodesModelDataItem data) => json.encode(data.toJson());


class GetOfferCodesModel {
  List<GetOfferCodesModelDataItem>? data;
  GetOfferCodesModelLinks? links;
  GetOfferCodesModelMeta? meta;

  GetOfferCodesModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetOfferCodesModel.fromJson(Map<String, dynamic> json) {
    return GetOfferCodesModel(
      data: json['data'] is List ? (json['data'] as List).whereType<Map>().map((item) => GetOfferCodesModelDataItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      links: json['links'] is Map ? GetOfferCodesModelLinks.fromJson(Map<String, dynamic>.from(json['links'] as Map)) : null,
      meta: json['meta'] is Map ? GetOfferCodesModelMeta.fromJson(Map<String, dynamic>.from(json['meta'] as Map)) : null,
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

class GetOfferCodesModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetOfferCodesModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetOfferCodesModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetOfferCodesModelMeta.fromJson(Map<String, dynamic> json) {
    return GetOfferCodesModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List ? (json['links'] as List).whereType<Map>().map((item) => GetOfferCodesModelMetaLinksItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
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

class GetOfferCodesModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetOfferCodesModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetOfferCodesModelMetaLinksItem.fromJson(Map<String, dynamic> json) {
    return GetOfferCodesModelMetaLinksItem(
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

class GetOfferCodesModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetOfferCodesModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetOfferCodesModelLinks.fromJson(Map<String, dynamic> json) {
    return GetOfferCodesModelLinks(
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

class GetOfferCodesModelDataItem {
  int? id;
  int? storeId;
  String? name;
  dynamic description;
  String? offerType;
  dynamic discountValue;
  int? discountPercent;
  dynamic startsAt;
  dynamic endsAt;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  GetOfferCodesModelDataItem({
    this.id,
    this.storeId,
    this.name,
    this.description,
    this.offerType,
    this.discountValue,
    this.discountPercent,
    this.startsAt,
    this.endsAt,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory GetOfferCodesModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetOfferCodesModelDataItem(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      name: _asString(json['name']),
      description: _asDynamic(json['description']),
      offerType: _asString(json['offerType']),
      discountValue: _asDynamic(json['discountValue']),
      discountPercent: _asInt(json['discountPercent']),
      startsAt: _asDynamic(json['startsAt']),
      endsAt: _asDynamic(json['endsAt']),
      isActive: _asBool(json['isActive']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'offerType': offerType,
      'discountValue': discountValue,
      'discountPercent': discountPercent,
      'startsAt': startsAt,
      'endsAt': endsAt,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}