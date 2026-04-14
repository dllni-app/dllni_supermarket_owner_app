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

FetchNotificationsModel fetchNotificationsModelFromJson(str) =>
    FetchNotificationsModel.fromJson(str);

String fetchNotificationsModelToJson(FetchNotificationsModel data) =>
    json.encode(data.toJson());

FetchNotificationsModelMeta fetchNotificationsModelMetaFromJson(str) =>
    FetchNotificationsModelMeta.fromJson(str);

String fetchNotificationsModelMetaToJson(FetchNotificationsModelMeta data) =>
    json.encode(data.toJson());

FetchNotificationsModelMetaLinksItem
fetchNotificationsModelMetaLinksItemFromJson(str) =>
    FetchNotificationsModelMetaLinksItem.fromJson(str);

String fetchNotificationsModelMetaLinksItemToJson(
  FetchNotificationsModelMetaLinksItem data,
) => json.encode(data.toJson());

FetchNotificationsModelLinks fetchNotificationsModelLinksFromJson(str) =>
    FetchNotificationsModelLinks.fromJson(str);

String fetchNotificationsModelLinksToJson(FetchNotificationsModelLinks data) =>
    json.encode(data.toJson());

FetchNotificationsModelDataItem fetchNotificationsModelDataItemFromJson(str) =>
    FetchNotificationsModelDataItem.fromJson(str);

String fetchNotificationsModelDataItemToJson(
  FetchNotificationsModelDataItem data,
) => json.encode(data.toJson());

class FetchNotificationsModel {
  List<FetchNotificationsModelDataItem>? data;
  FetchNotificationsModelLinks? links;
  FetchNotificationsModelMeta? meta;

  FetchNotificationsModel({this.data, this.links, this.meta});

  factory FetchNotificationsModel.fromJson(Map<String, dynamic> json) {
    return FetchNotificationsModel(
      data: json['data'] is List
          ? (json['data'] as List)
                .whereType<Map>()
                .map(
                  (item) => FetchNotificationsModelDataItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : null,
      links: json['links'] is Map
          ? FetchNotificationsModelLinks.fromJson(
              Map<String, dynamic>.from(json['links'] as Map),
            )
          : null,
      meta: json['meta'] is Map
          ? FetchNotificationsModelMeta.fromJson(
              Map<String, dynamic>.from(json['meta'] as Map),
            )
          : null,
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

class FetchNotificationsModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<FetchNotificationsModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  FetchNotificationsModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory FetchNotificationsModelMeta.fromJson(Map<String, dynamic> json) {
    return FetchNotificationsModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List
          ? (json['links'] as List)
                .whereType<Map>()
                .map(
                  (item) => FetchNotificationsModelMetaLinksItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : null,
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

class FetchNotificationsModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  FetchNotificationsModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory FetchNotificationsModelMetaLinksItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return FetchNotificationsModelMetaLinksItem(
      url: _asString(json['url']),
      label: _asString(json['label']),
      page: _asInt(json['page']),
      active: _asBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label, 'page': page, 'active': active};
  }
}

class FetchNotificationsModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  FetchNotificationsModelLinks({this.first, this.last, this.prev, this.next});

  factory FetchNotificationsModelLinks.fromJson(Map<String, dynamic> json) {
    return FetchNotificationsModelLinks(
      first: _asString(json['first']),
      last: _asString(json['last']),
      prev: _asDynamic(json['prev']),
      next: _asDynamic(json['next']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'first': first, 'last': last, 'prev': prev, 'next': next};
  }
}

class FetchNotificationsModelDataItem {
  String? id;
  String? type;
  String? title;
  String? body;
  dynamic data;
  String? readAt;
  String? icon;
  String? createdAt;

  FetchNotificationsModelDataItem({
    this.id,
    this.type,
    this.title,
    this.body,
    this.data,
    this.readAt,
    this.icon,
    this.createdAt,
  });

  factory FetchNotificationsModelDataItem.fromJson(Map<String, dynamic> json) {
    return FetchNotificationsModelDataItem(
      id: _asString(json['id']),
      type: _asString(json['type']),
      title: _asString(json['title']),
      body: _asString(json['body']),
      data: _asDynamic(json['data']),
      readAt: _asString(json['readAt']),
      icon: _asString(json["icon"]),
      createdAt: _asString(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'readAt': readAt,
      'createdAt': createdAt,
    };
  }
}
