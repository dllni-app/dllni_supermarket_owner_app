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

GetCouponWeekAnalysisModel getCouponWeekAnalysisModelFromJson(str) => GetCouponWeekAnalysisModel.fromJson(str);

String getCouponWeekAnalysisModelToJson(GetCouponWeekAnalysisModel data) => json.encode(data.toJson());


GetCouponWeekAnalysisModelData getCouponWeekAnalysisModelDataFromJson(str) => GetCouponWeekAnalysisModelData.fromJson(str);

String getCouponWeekAnalysisModelDataToJson(GetCouponWeekAnalysisModelData data) => json.encode(data.toJson());


GetCouponWeekAnalysisModelDataDaysItem getCouponWeekAnalysisModelDataDaysItemFromJson(str) => GetCouponWeekAnalysisModelDataDaysItem.fromJson(str);

String getCouponWeekAnalysisModelDataDaysItemToJson(GetCouponWeekAnalysisModelDataDaysItem data) => json.encode(data.toJson());


class GetCouponWeekAnalysisModel {
  String? message;
  GetCouponWeekAnalysisModelData? data;

  GetCouponWeekAnalysisModel({
    this.message,
    this.data,
  });

  factory GetCouponWeekAnalysisModel.fromJson(Map<String, dynamic> json) {
    return GetCouponWeekAnalysisModel(
      message: _asString(json['message']),
      data: json['data'] is Map ? GetCouponWeekAnalysisModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class GetCouponWeekAnalysisModelData {
  String? startDate;
  String? endDate;
  List<GetCouponWeekAnalysisModelDataDaysItem>? days;
  int? totalUsedDiscountAmount;

  GetCouponWeekAnalysisModelData({
    this.startDate,
    this.endDate,
    this.days,
    this.totalUsedDiscountAmount,
  });

  factory GetCouponWeekAnalysisModelData.fromJson(Map<String, dynamic> json) {
    return GetCouponWeekAnalysisModelData(
      startDate: _asString(json['startDate']),
      endDate: _asString(json['endDate']),
      days: json['days'] is List ? (json['days'] as List).whereType<Map>().map((item) => GetCouponWeekAnalysisModelDataDaysItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      totalUsedDiscountAmount: _asInt(json['totalUsedDiscountAmount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'days': days?.map((item) => item.toJson()).toList(),
      'totalUsedDiscountAmount': totalUsedDiscountAmount,
    };
  }
}

class GetCouponWeekAnalysisModelDataDaysItem {
  String? date;
  String? day;
  int? activeCoupons;
  int? inactiveCoupons;

  GetCouponWeekAnalysisModelDataDaysItem({
    this.date,
    this.day,
    this.activeCoupons,
    this.inactiveCoupons,
  });

  factory GetCouponWeekAnalysisModelDataDaysItem.fromJson(Map<String, dynamic> json) {
    return GetCouponWeekAnalysisModelDataDaysItem(
      date: _asString(json['date']),
      day: _asString(json['day']),
      activeCoupons: _asInt(json['activeCoupons']),
      inactiveCoupons: _asInt(json['inactiveCoupons']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'activeCoupons': activeCoupons,
      'inactiveCoupons': inactiveCoupons,
    };
  }
}