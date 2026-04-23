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

GetActivityLogsModel getActivityLogsModelFromJson(dynamic str) =>
    GetActivityLogsModel.fromJson(Map<String, dynamic>.from(str as Map));

class GetActivityLogsModel {
  List<GetActivityLogsModelDataItem>? data;
  GetActivityLogsModelLinks? links;
  GetActivityLogsModelMeta? meta;

  GetActivityLogsModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetActivityLogsModel.fromJson(Map<String, dynamic> json) {
    return GetActivityLogsModel(
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map>()
              .map(
                (item) => GetActivityLogsModelDataItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : null,
      links: json['links'] is Map
          ? GetActivityLogsModelLinks.fromJson(
              Map<String, dynamic>.from(json['links'] as Map),
            )
          : null,
      meta: json['meta'] is Map
          ? GetActivityLogsModelMeta.fromJson(
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

class GetActivityLogsModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetActivityLogsModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetActivityLogsModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetActivityLogsModelMeta.fromJson(Map<String, dynamic> json) {
    return GetActivityLogsModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List
          ? (json['links'] as List)
              .whereType<Map>()
              .map(
                (item) => GetActivityLogsModelMetaLinksItem.fromJson(
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

class GetActivityLogsModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetActivityLogsModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetActivityLogsModelMetaLinksItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetActivityLogsModelMetaLinksItem(
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

class GetActivityLogsModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetActivityLogsModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetActivityLogsModelLinks.fromJson(Map<String, dynamic> json) {
    return GetActivityLogsModelLinks(
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

class GetActivityLogsModelCauser {
  String? id;
  String? name;
  String? avatarUrl;

  GetActivityLogsModelCauser({
    this.id,
    this.name,
    this.avatarUrl,
  });

  factory GetActivityLogsModelCauser.fromJson(Map<String, dynamic> json) {
    return GetActivityLogsModelCauser(
      id: _asString(json['id']),
      name: _asString(json['name']),
      avatarUrl: _asString(json['avatarUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}

class GetActivityLogsModelDataItem {
  String? id;
  String? description;
  String? event;
  String? logName;
  GetActivityLogsModelCauser? causer;
  String? subjectType;
  String? subjectId;
  String? properties;
  String? createdAt;

  GetActivityLogsModelDataItem({
    this.id,
    this.description,
    this.event,
    this.logName,
    this.causer,
    this.subjectType,
    this.subjectId,
    this.properties,
    this.createdAt,
  });

  factory GetActivityLogsModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetActivityLogsModelDataItem(
      id: _asString(json['id']),
      description: _asString(json['description']),
      event: _asString(json['event']),
      logName: _asString(json['logName']),
      causer: json['causer'] is Map
          ? GetActivityLogsModelCauser.fromJson(
              Map<String, dynamic>.from(json['causer'] as Map),
            )
          : null,
      subjectType: _asString(json['subjectType']),
      subjectId: _asString(json['subjectId']),
      properties: json['properties'] == null
          ? null
          : json['properties'] is String
              ? json['properties'] as String
              : jsonEncode(_asDynamic(json['properties'])),
      createdAt: _asString(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'event': event,
      'logName': logName,
      'causer': causer?.toJson(),
      'subjectType': subjectType,
      'subjectId': subjectId,
      'properties': properties,
      'createdAt': createdAt,
    };
  }
}
