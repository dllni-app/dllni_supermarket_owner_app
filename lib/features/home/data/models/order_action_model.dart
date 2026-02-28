import 'dart:convert';

OrderActionModel orderActionModelFromJson(dynamic str) => OrderActionModel.fromJson(str);

String orderActionModelToJson(OrderActionModel data) => json.encode(data.toJson());

class OrderActionModel {
  final String? message;
  final Map<String, dynamic>? data;

  OrderActionModel({this.message, this.data});

  factory OrderActionModel.fromJson(Map<String, dynamic> json) {
    return OrderActionModel(
      message: json['message']?.toString(),
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
    };
  }
}
