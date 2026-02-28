import 'dart:convert';

DashboardModel dashboardModelFromJson(dynamic str) => DashboardModel.fromJson(str);

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  final String? message;
  final DashboardData? data;

  DashboardModel({this.message, this.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      message: json['message']?.toString(),
      data: json['data'] is Map ? DashboardData.fromJson(Map<String, dynamic>.from(json['data'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DashboardData {
  final num? totalOrders;
  final num? completedOrders;
  final num? newOrders;
  final num? pendingOrders;
  final num? totalSales;

  DashboardData({
    this.totalOrders,
    this.completedOrders,
    this.newOrders,
    this.pendingOrders,
    this.totalSales,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalOrders: json['totalOrders'] as num?,
      completedOrders: json['completedOrders'] as num?,
      newOrders: json['newOrders'] as num?,
      pendingOrders: json['pendingOrders'] as num?,
      totalSales: json['totalSales'] as num?,
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
