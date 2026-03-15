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

UpdateStoreHoursModel updateStoreHoursModelFromJson(str) => UpdateStoreHoursModel.fromJson(str);

String updateStoreHoursModelToJson(UpdateStoreHoursModel data) => json.encode(data.toJson());


UpdateStoreHoursModelData updateStoreHoursModelDataFromJson(str) => UpdateStoreHoursModelData.fromJson(str);

String updateStoreHoursModelDataToJson(UpdateStoreHoursModelData data) => json.encode(data.toJson());


class UpdateStoreHoursModel {
  UpdateStoreHoursModelData? data;

  UpdateStoreHoursModel({
    this.data,
  });

  factory UpdateStoreHoursModel.fromJson(Map<String, dynamic> json) {
    return UpdateStoreHoursModel(
      data: json['data'] is Map ? UpdateStoreHoursModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class UpdateStoreHoursModelData {
  int? id;
  int? storeId;
  int? dayOfWeek;
  String? opensAt;
  String? closesAt;
  bool? isClosed;
  String? createdAt;
  String? updatedAt;

  UpdateStoreHoursModelData({
    this.id,
    this.storeId,
    this.dayOfWeek,
    this.opensAt,
    this.closesAt,
    this.isClosed,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateStoreHoursModelData.fromJson(Map<String, dynamic> json) {
    return UpdateStoreHoursModelData(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      dayOfWeek: _asInt(json['dayOfWeek']),
      opensAt: _asString(json['opensAt']),
      closesAt: _asString(json['closesAt']),
      isClosed: _asBool(json['isClosed']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'dayOfWeek': dayOfWeek,
      'opensAt': opensAt,
      'closesAt': closesAt,
      'isClosed': isClosed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}