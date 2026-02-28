import 'dart:convert';

OrdersListModel ordersListModelFromJson(dynamic str) => OrdersListModel.fromJson(str);

String ordersListModelToJson(OrdersListModel data) => json.encode(data.toJson());

class OrdersListModel {
  final List<OrderItem> data;

  OrdersListModel({this.data = const []});

  factory OrdersListModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'];
    return OrdersListModel(
      data: items is List
          ? items.whereType<Map>().map((item) => OrderItem.fromJson(Map<String, dynamic>.from(item))).toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int? id;
  final String? orderNumber;
  final String? status;
  final String? totalAmount;
  final String? createdAt;
  final CustomerInfo? customer;

  OrderItem({
    this.id,
    this.orderNumber,
    this.status,
    this.totalAmount,
    this.createdAt,
    this.customer,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int?,
      orderNumber: (json['orderNumber'] ?? json['order_number'])?.toString(),
      status: json['status']?.toString(),
      totalAmount: (json['totalAmount'] ?? json['total_amount'])?.toString(),
      createdAt: (json['createdAt'] ?? json['created_at'])?.toString(),
      customer: json['customer'] is Map ? CustomerInfo.fromJson(Map<String, dynamic>.from(json['customer'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'customer': customer?.toJson(),
    };
  }
}

class CustomerInfo {
  final int? id;
  final String? name;
  final String? email;

  CustomerInfo({this.id, this.name, this.email});

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['id'] as int?,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
