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

num? _asNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

GetDashboardOverviewModel getDashboardOverviewModelFromJson(str) =>
    GetDashboardOverviewModel.fromJson(str);

String getDashboardOverviewModelToJson(GetDashboardOverviewModel data) =>
    json.encode(data.toJson());

GetDashboardOverviewModelData getDashboardOverviewModelDataFromJson(str) =>
    GetDashboardOverviewModelData.fromJson(str);

String getDashboardOverviewModelDataToJson(
  GetDashboardOverviewModelData data,
) => json.encode(data.toJson());

class GetDashboardOverviewModel {
  String? message;
  GetDashboardOverviewModelData? data;

  GetDashboardOverviewModel({this.message, this.data});

  factory GetDashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return GetDashboardOverviewModel(
      message: _asString(json['message']),
      data: json['data'] is Map
          ? GetDashboardOverviewModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.toJson()};
  }
}

class GetDashboardOverviewModelData {
  int? totalOrders;
  int? completedOrders;
  int? newOrders;
  int? pendingOrders;
  int? totalSales;
  int? salesPercentageChange;
  num? merchantGrossSales;
  num? merchantNetSales;
  num? platformCommission;
  num? merchantCouponFunding;
  int? unsnapshottedOrders;

  GetDashboardOverviewModelData({
    this.totalOrders,
    this.completedOrders,
    this.newOrders,
    this.pendingOrders,
    this.totalSales,
    this.salesPercentageChange,
    this.merchantGrossSales,
    this.merchantNetSales,
    this.platformCommission,
    this.merchantCouponFunding,
    this.unsnapshottedOrders,
  });

  factory GetDashboardOverviewModelData.fromJson(Map<String, dynamic> json) {
    return GetDashboardOverviewModelData(
      totalOrders: _asInt(json['totalOrders']),
      completedOrders: _asInt(json['completedOrders']),
      newOrders: _asInt(json['newOrders']),
      pendingOrders: _asInt(json['pendingOrders']),
      totalSales: _asInt(json['totalSales']),
      salesPercentageChange: _asInt(json['salesPercentageChange']),
      merchantGrossSales: _asNum(json['merchantGrossSales']),
      merchantNetSales: _asNum(json['merchantNetSales']),
      platformCommission: _asNum(json['platformCommission']),
      merchantCouponFunding: _asNum(json['merchantCouponFunding']),
      unsnapshottedOrders: _asInt(json['unsnapshottedOrders']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'newOrders': newOrders,
      'pendingOrders': pendingOrders,
      'totalSales': totalSales,
      'salesPercentageChange': salesPercentageChange,
      'merchantGrossSales': merchantGrossSales,
      'merchantNetSales': merchantNetSales,
      'platformCommission': platformCommission,
      'merchantCouponFunding': merchantCouponFunding,
      'unsnapshottedOrders': unsnapshottedOrders,
    };
  }
}
