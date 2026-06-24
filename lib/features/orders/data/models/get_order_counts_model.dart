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

GetOrderCountsModel getOrderCountsModelFromJson(str) => GetOrderCountsModel.fromJson(str);

String getOrderCountsModelToJson(GetOrderCountsModel data) => json.encode(data.toJson());


GetOrderCountsModelData getOrderCountsModelDataFromJson(str) => GetOrderCountsModelData.fromJson(str);

String getOrderCountsModelDataToJson(GetOrderCountsModelData data) => json.encode(data.toJson());


class GetOrderCountsModel {
  bool? success;
  String? message;
  GetOrderCountsModelData? data;

  GetOrderCountsModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetOrderCountsModel.fromJson(Map<String, dynamic> json) {
    return GetOrderCountsModel(
      success: _asBool(json['success']),
      message: _asString(json['message']),
      data: json['data'] is Map ? GetOrderCountsModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
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

class GetOrderCountsModelData {
  int? total;
  int? pending;
  int? accepted;
  int? preparing;
  int? readyForDelivery;
  int? courierHandover;
  int? completed;
  int? cancelled;

  GetOrderCountsModelData({
    this.total,
    this.pending,
    this.accepted,
    this.preparing,
    this.readyForDelivery,
    this.courierHandover,
    this.completed,
    this.cancelled,
  });

  factory GetOrderCountsModelData.fromJson(Map<String, dynamic> json) {
    return GetOrderCountsModelData(
      total: _asInt(json['total']),
      pending: _asInt(json['pending']),
      accepted: _asInt(json['accepted']),
      preparing: _asInt(json['preparing']),
      readyForDelivery: _asInt(json['ready_for_delivery']),
      courierHandover: _asInt(json['courier_handover']),
      completed: _asInt(json['completed']),
      cancelled: _asInt(json['cancelled']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'pending': pending,
      'accepted': accepted,
      'preparing': preparing,
      'ready_for_delivery': readyForDelivery,
      'courier_handover': courierHandover,
      'completed': completed,
      'cancelled': cancelled,
    };
  }
}