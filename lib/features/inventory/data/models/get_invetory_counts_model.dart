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

GetInvetoryCountsModel getInvetoryCountsModelFromJson(str) => GetInvetoryCountsModel.fromJson(str);

String getInvetoryCountsModelToJson(GetInvetoryCountsModel data) => json.encode(data.toJson());


GetInvetoryCountsModelData getInvetoryCountsModelDataFromJson(str) => GetInvetoryCountsModelData.fromJson(str);

String getInvetoryCountsModelDataToJson(GetInvetoryCountsModelData data) => json.encode(data.toJson());


class GetInvetoryCountsModel {
  bool? success;
  String? message;
  GetInvetoryCountsModelData? data;

  GetInvetoryCountsModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetInvetoryCountsModel.fromJson(Map<String, dynamic> json) {
    return GetInvetoryCountsModel(
      success: _asBool(json['success']),
      message: _asString(json['message']),
      data: json['data'] is Map ? GetInvetoryCountsModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GetInvetoryCountsModelData {
  int? total;
  int? normal;
  int? lowStock;
  int? outOfStock;
  int? available;
  int? unavailable;

  GetInvetoryCountsModelData({
    this.total,
    this.normal,
    this.lowStock,
    this.outOfStock,
    this.available,
    this.unavailable,
  });

  factory GetInvetoryCountsModelData.fromJson(Map<String, dynamic> json) {
    return GetInvetoryCountsModelData(
      total: _asInt(json['total']),
      normal: _asInt(json['normal']),
      lowStock: _asInt(json['low_stock']),
      outOfStock: _asInt(json['out_of_stock']),
      available: _asInt(json['available']),
      unavailable: _asInt(json['unavailable']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'normal': normal,
      'low_stock': lowStock,
      'out_of_stock': outOfStock,
      'available': available,
      'unavailable': unavailable,
    };
  }
}