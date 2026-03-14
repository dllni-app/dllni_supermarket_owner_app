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

GetPerformanceReportModel getPerformanceReportModelFromJson(str) => GetPerformanceReportModel.fromJson(str);

String getPerformanceReportModelToJson(GetPerformanceReportModel data) => json.encode(data.toJson());


GetPerformanceReportModelPeriod getPerformanceReportModelPeriodFromJson(str) => GetPerformanceReportModelPeriod.fromJson(str);

String getPerformanceReportModelPeriodToJson(GetPerformanceReportModelPeriod data) => json.encode(data.toJson());


GetPerformanceReportModelOperationalMetrics getPerformanceReportModelOperationalMetricsFromJson(str) => GetPerformanceReportModelOperationalMetrics.fromJson(str);

String getPerformanceReportModelOperationalMetricsToJson(GetPerformanceReportModelOperationalMetrics data) => json.encode(data.toJson());


class GetPerformanceReportModel {
  List<dynamic>? topProducts;
  List<dynamic>? topStores;
  GetPerformanceReportModelOperationalMetrics? operationalMetrics;
  List<dynamic>? trends;
  GetPerformanceReportModelPeriod? period;

  GetPerformanceReportModel({
    this.topProducts,
    this.topStores,
    this.operationalMetrics,
    this.trends,
    this.period,
  });

  factory GetPerformanceReportModel.fromJson(Map<String, dynamic> json) {
    return GetPerformanceReportModel(
      topProducts: _asDynamicList(json['top_products']),
      topStores: _asDynamicList(json['top_stores']),
      operationalMetrics: json['operational_metrics'] is Map ? GetPerformanceReportModelOperationalMetrics.fromJson(Map<String, dynamic>.from(json['operational_metrics'] as Map)) : null,
      trends: _asDynamicList(json['trends']),
      period: json['period'] is Map ? GetPerformanceReportModelPeriod.fromJson(Map<String, dynamic>.from(json['period'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_products': topProducts,
      'top_stores': topStores,
      'operational_metrics': operationalMetrics?.toJson(),
      'trends': trends,
      'period': period?.toJson(),
    };
  }
}

class GetPerformanceReportModelPeriod {
  String? startDate;
  String? endDate;

  GetPerformanceReportModelPeriod({
    this.startDate,
    this.endDate,
  });

  factory GetPerformanceReportModelPeriod.fromJson(Map<String, dynamic> json) {
    return GetPerformanceReportModelPeriod(
      startDate: _asString(json['start_date']),
      endDate: _asString(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class GetPerformanceReportModelOperationalMetrics {
  int? averageBasketValue;
  int? completionRate;
  int? cancellationRate;
  int? totalOrders;

  GetPerformanceReportModelOperationalMetrics({
    this.averageBasketValue,
    this.completionRate,
    this.cancellationRate,
    this.totalOrders,
  });

  factory GetPerformanceReportModelOperationalMetrics.fromJson(Map<String, dynamic> json) {
    return GetPerformanceReportModelOperationalMetrics(
      averageBasketValue: _asInt(json['average_basket_value']),
      completionRate: _asInt(json['completion_rate']),
      cancellationRate: _asInt(json['cancellation_rate']),
      totalOrders: _asInt(json['total_orders']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_basket_value': averageBasketValue,
      'completion_rate': completionRate,
      'cancellation_rate': cancellationRate,
      'total_orders': totalOrders,
    };
  }
}