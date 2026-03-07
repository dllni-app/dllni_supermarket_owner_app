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

GetDashboardOverviewModel getDashboardOverviewModelFromJson(str) => GetDashboardOverviewModel.fromJson(str);

String getDashboardOverviewModelToJson(GetDashboardOverviewModel data) => json.encode(data.toJson());


GetDashboardOverviewModelData getDashboardOverviewModelDataFromJson(str) => GetDashboardOverviewModelData.fromJson(str);

String getDashboardOverviewModelDataToJson(GetDashboardOverviewModelData data) => json.encode(data.toJson());


class GetDashboardOverviewModel {
  String? message;
  GetDashboardOverviewModelData? data;

  GetDashboardOverviewModel({
    this.message,
    this.data,
  });

  factory GetDashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return GetDashboardOverviewModel(
      message: _asString(json['message']),
      data: json['data'] is Map ? GetDashboardOverviewModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GetDashboardOverviewModelData {
  int? totalOrders;
  int? completedOrders;
  int? newOrders;
  int? pendingOrders;
  int? totalSales;

  GetDashboardOverviewModelData({
    this.totalOrders,
    this.completedOrders,
    this.newOrders,
    this.pendingOrders,
    this.totalSales,
  });

  factory GetDashboardOverviewModelData.fromJson(Map<String, dynamic> json) {
    return GetDashboardOverviewModelData(
      totalOrders: _asInt(json['totalOrders']),
      completedOrders: _asInt(json['completedOrders']),
      newOrders: _asInt(json['newOrders']),
      pendingOrders: _asInt(json['pendingOrders']),
      totalSales: _asInt(json['totalSales']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'newOrders': newOrders,
      'pendingOrders': pendingOrders,
      'totalSales': totalSales,
    };
  }
}