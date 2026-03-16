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

GetOffersWeeklySummaryModel getOffersWeeklySummaryModelFromJson(str) => GetOffersWeeklySummaryModel.fromJson(str);

String getOffersWeeklySummaryModelToJson(GetOffersWeeklySummaryModel data) => json.encode(data.toJson());


GetOffersWeeklySummaryModelData getOffersWeeklySummaryModelDataFromJson(str) => GetOffersWeeklySummaryModelData.fromJson(str);

String getOffersWeeklySummaryModelDataToJson(GetOffersWeeklySummaryModelData data) => json.encode(data.toJson());


GetOffersWeeklySummaryModelDataTotals getOffersWeeklySummaryModelDataTotalsFromJson(str) => GetOffersWeeklySummaryModelDataTotals.fromJson(str);

String getOffersWeeklySummaryModelDataTotalsToJson(GetOffersWeeklySummaryModelDataTotals data) => json.encode(data.toJson());


GetOffersWeeklySummaryModelDataSeriesItem getOffersWeeklySummaryModelDataSeriesItemFromJson(str) => GetOffersWeeklySummaryModelDataSeriesItem.fromJson(str);

String getOffersWeeklySummaryModelDataSeriesItemToJson(GetOffersWeeklySummaryModelDataSeriesItem data) => json.encode(data.toJson());


GetOffersWeeklySummaryModelDataWeek getOffersWeeklySummaryModelDataWeekFromJson(str) => GetOffersWeeklySummaryModelDataWeek.fromJson(str);

String getOffersWeeklySummaryModelDataWeekToJson(GetOffersWeeklySummaryModelDataWeek data) => json.encode(data.toJson());


class GetOffersWeeklySummaryModel {
  String? message;
  GetOffersWeeklySummaryModelData? data;

  GetOffersWeeklySummaryModel({
    this.message,
    this.data,
  });

  factory GetOffersWeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return GetOffersWeeklySummaryModel(
      message: _asString(json['message']),
      data: json['data'] is Map ? GetOffersWeeklySummaryModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GetOffersWeeklySummaryModelData {
  GetOffersWeeklySummaryModelDataWeek? week;
  List<GetOffersWeeklySummaryModelDataSeriesItem>? series;
  GetOffersWeeklySummaryModelDataTotals? totals;

  GetOffersWeeklySummaryModelData({
    this.week,
    this.series,
    this.totals,
  });

  factory GetOffersWeeklySummaryModelData.fromJson(Map<String, dynamic> json) {
    return GetOffersWeeklySummaryModelData(
      week: json['week'] is Map ? GetOffersWeeklySummaryModelDataWeek.fromJson(Map<String, dynamic>.from(json['week'] as Map)) : null,
      series: json['series'] is List ? (json['series'] as List).whereType<Map>().map((item) => GetOffersWeeklySummaryModelDataSeriesItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      totals: json['totals'] is Map ? GetOffersWeeklySummaryModelDataTotals.fromJson(Map<String, dynamic>.from(json['totals'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week?.toJson(),
      'series': series?.map((item) => item.toJson()).toList(),
      'totals': totals?.toJson(),
    };
  }
}

class GetOffersWeeklySummaryModelDataTotals {
  int? activeOffers;
  int? scheduledOffers;
  int? ordersUsedOffers;
  int? endedOffers;

  GetOffersWeeklySummaryModelDataTotals({
    this.activeOffers,
    this.scheduledOffers,
    this.ordersUsedOffers,
    this.endedOffers,
  });

  factory GetOffersWeeklySummaryModelDataTotals.fromJson(Map<String, dynamic> json) {
    return GetOffersWeeklySummaryModelDataTotals(
      activeOffers: _asInt(json['activeOffers']),
      scheduledOffers: _asInt(json['scheduledOffers']),
      ordersUsedOffers: _asInt(json['ordersUsedOffers']),
      endedOffers: _asInt(json['endedOffers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeOffers': activeOffers,
      'scheduledOffers': scheduledOffers,
      'ordersUsedOffers': ordersUsedOffers,
      'endedOffers': endedOffers,
    };
  }
}

class GetOffersWeeklySummaryModelDataSeriesItem {
  String? day;
  int? activeOffers;
  int? scheduledOffers;
  int? ordersUsedOffers;

  GetOffersWeeklySummaryModelDataSeriesItem({
    this.day,
    this.activeOffers,
    this.scheduledOffers,
    this.ordersUsedOffers,
  });

  factory GetOffersWeeklySummaryModelDataSeriesItem.fromJson(Map<String, dynamic> json) {
    return GetOffersWeeklySummaryModelDataSeriesItem(
      day: _asString(json['day']),
      activeOffers: _asInt(json['activeOffers']),
      scheduledOffers: _asInt(json['scheduledOffers']),
      ordersUsedOffers: _asInt(json['ordersUsedOffers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'activeOffers': activeOffers,
      'scheduledOffers': scheduledOffers,
      'ordersUsedOffers': ordersUsedOffers,
    };
  }
}

class GetOffersWeeklySummaryModelDataWeek {
  String? startDate;
  String? endDate;
  String? weekStartsOn;

  GetOffersWeeklySummaryModelDataWeek({
    this.startDate,
    this.endDate,
    this.weekStartsOn,
  });

  factory GetOffersWeeklySummaryModelDataWeek.fromJson(Map<String, dynamic> json) {
    return GetOffersWeeklySummaryModelDataWeek(
      startDate: _asString(json['startDate']),
      endDate: _asString(json['endDate']),
      weekStartsOn: _asString(json['weekStartsOn']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'weekStartsOn': weekStartsOn,
    };
  }
}