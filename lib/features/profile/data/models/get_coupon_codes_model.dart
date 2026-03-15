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

GetCouponCodesModel getCouponCodesModelFromJson(str) => GetCouponCodesModel.fromJson(str);

String getCouponCodesModelToJson(GetCouponCodesModel data) => json.encode(data.toJson());


GetCouponCodesModelMeta getCouponCodesModelMetaFromJson(str) => GetCouponCodesModelMeta.fromJson(str);

String getCouponCodesModelMetaToJson(GetCouponCodesModelMeta data) => json.encode(data.toJson());


GetCouponCodesModelMetaLinksItem getCouponCodesModelMetaLinksItemFromJson(str) => GetCouponCodesModelMetaLinksItem.fromJson(str);

String getCouponCodesModelMetaLinksItemToJson(GetCouponCodesModelMetaLinksItem data) => json.encode(data.toJson());


GetCouponCodesModelLinks getCouponCodesModelLinksFromJson(str) => GetCouponCodesModelLinks.fromJson(str);

String getCouponCodesModelLinksToJson(GetCouponCodesModelLinks data) => json.encode(data.toJson());


GetCouponCodesModelDataItem getCouponCodesModelDataItemFromJson(str) => GetCouponCodesModelDataItem.fromJson(str);

String getCouponCodesModelDataItemToJson(GetCouponCodesModelDataItem data) => json.encode(data.toJson());


class GetCouponCodesModel {
  List<GetCouponCodesModelDataItem>? data;
  GetCouponCodesModelLinks? links;
  GetCouponCodesModelMeta? meta;

  GetCouponCodesModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetCouponCodesModel.fromJson(Map<String, dynamic> json) {
    return GetCouponCodesModel(
      data: json['data'] is List ? (json['data'] as List).whereType<Map>().map((item) => GetCouponCodesModelDataItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      links: json['links'] is Map ? GetCouponCodesModelLinks.fromJson(Map<String, dynamic>.from(json['links'] as Map)) : null,
      meta: json['meta'] is Map ? GetCouponCodesModelMeta.fromJson(Map<String, dynamic>.from(json['meta'] as Map)) : null,
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

class GetCouponCodesModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetCouponCodesModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetCouponCodesModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetCouponCodesModelMeta.fromJson(Map<String, dynamic> json) {
    return GetCouponCodesModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List ? (json['links'] as List).whereType<Map>().map((item) => GetCouponCodesModelMetaLinksItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
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

class GetCouponCodesModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetCouponCodesModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetCouponCodesModelMetaLinksItem.fromJson(Map<String, dynamic> json) {
    return GetCouponCodesModelMetaLinksItem(
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

class GetCouponCodesModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetCouponCodesModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetCouponCodesModelLinks.fromJson(Map<String, dynamic> json) {
    return GetCouponCodesModelLinks(
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

class GetCouponCodesModelDataItem {
  int? id;
  int? storeId;
  String? code;
  String? type;
  String? value;
  int? percent;
  String? minOrderAmount;
  String? maxDiscountAmount;
  int? usageLimit;
  int? usedCount;
  String? startsAt;
  String? endsAt;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  GetCouponCodesModelDataItem({
    this.id,
    this.storeId,
    this.code,
    this.type,
    this.value,
    this.percent,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.usageLimit,
    this.usedCount,
    this.startsAt,
    this.endsAt,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory GetCouponCodesModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetCouponCodesModelDataItem(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      code: _asString(json['code']),
      type: _asString(json['type']),
      value: _asString(json['value']),
      percent: _asInt(json['percent']),
      minOrderAmount: _asString(json['minOrderAmount']),
      maxDiscountAmount: _asString(json['maxDiscountAmount']),
      usageLimit: _asInt(json['usageLimit']),
      usedCount: _asInt(json['usedCount']),
      startsAt: _asString(json['startsAt']),
      endsAt: _asString(json['endsAt']),
      isActive: _asBool(json['isActive']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'code': code,
      'type': type,
      'value': value,
      'percent': percent,
      'minOrderAmount': minOrderAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'startsAt': startsAt,
      'endsAt': endsAt,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}