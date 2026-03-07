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

RejectOrderModel rejectOrderModelFromJson(str) => RejectOrderModel.fromJson(str);

String rejectOrderModelToJson(RejectOrderModel data) => json.encode(data.toJson());


RejectOrderModelData rejectOrderModelDataFromJson(str) => RejectOrderModelData.fromJson(str);

String rejectOrderModelDataToJson(RejectOrderModelData data) => json.encode(data.toJson());


RejectOrderModelDataItemsItem rejectOrderModelDataItemsItemFromJson(str) => RejectOrderModelDataItemsItem.fromJson(str);

String rejectOrderModelDataItemsItemToJson(RejectOrderModelDataItemsItem data) => json.encode(data.toJson());


RejectOrderModelDataStore rejectOrderModelDataStoreFromJson(str) => RejectOrderModelDataStore.fromJson(str);

String rejectOrderModelDataStoreToJson(RejectOrderModelDataStore data) => json.encode(data.toJson());


RejectOrderModelDataCustomer rejectOrderModelDataCustomerFromJson(str) => RejectOrderModelDataCustomer.fromJson(str);

String rejectOrderModelDataCustomerToJson(RejectOrderModelDataCustomer data) => json.encode(data.toJson());


class RejectOrderModel {
  String? message;
  RejectOrderModelData? data;

  RejectOrderModel({
    this.message,
    this.data,
  });

  factory RejectOrderModel.fromJson(Map<String, dynamic> json) {
    return RejectOrderModel(
      message: _asString(json['message']),
      data: json['data'] is Map ? RejectOrderModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class RejectOrderModelData {
  int? id;
  int? customerId;
  RejectOrderModelDataCustomer? customer;
  int? storeId;
  RejectOrderModelDataStore? store;
  dynamic couponId;
  dynamic coupon;
  String? orderNumber;
  String? status;
  String? pickupMode;
  int? subtotal;
  int? discountAmount;
  int? serviceFee;
  int? totalAmount;
  dynamic specialInstructions;
  String? cancelledAt;
  String? cancellationReason;
  List<RejectOrderModelDataItemsItem>? items;
  List<dynamic>? statusLogs;
  List<dynamic>? disputes;
  String? createdAt;
  String? updatedAt;

  RejectOrderModelData({
    this.id,
    this.customerId,
    this.customer,
    this.storeId,
    this.store,
    this.couponId,
    this.coupon,
    this.orderNumber,
    this.status,
    this.pickupMode,
    this.subtotal,
    this.discountAmount,
    this.serviceFee,
    this.totalAmount,
    this.specialInstructions,
    this.cancelledAt,
    this.cancellationReason,
    this.items,
    this.statusLogs,
    this.disputes,
    this.createdAt,
    this.updatedAt,
  });

  factory RejectOrderModelData.fromJson(Map<String, dynamic> json) {
    return RejectOrderModelData(
      id: _asInt(json['id']),
      customerId: _asInt(json['customerId']),
      customer: json['customer'] is Map ? RejectOrderModelDataCustomer.fromJson(Map<String, dynamic>.from(json['customer'] as Map)) : null,
      storeId: _asInt(json['storeId']),
      store: json['store'] is Map ? RejectOrderModelDataStore.fromJson(Map<String, dynamic>.from(json['store'] as Map)) : null,
      couponId: _asDynamic(json['couponId']),
      coupon: _asDynamic(json['coupon']),
      orderNumber: _asString(json['orderNumber']),
      status: _asString(json['status']),
      pickupMode: _asString(json['pickupMode']),
      subtotal: _asInt(json['subtotal']),
      discountAmount: _asInt(json['discountAmount']),
      serviceFee: _asInt(json['serviceFee']),
      totalAmount: _asInt(json['totalAmount']),
      specialInstructions: _asDynamic(json['specialInstructions']),
      cancelledAt: _asString(json['cancelledAt']),
      cancellationReason: _asString(json['cancellationReason']),
      items: json['items'] is List ? (json['items'] as List).whereType<Map>().map((item) => RejectOrderModelDataItemsItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      statusLogs: _asDynamicList(json['statusLogs']),
      disputes: _asDynamicList(json['disputes']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customer': customer?.toJson(),
      'storeId': storeId,
      'store': store?.toJson(),
      'couponId': couponId,
      'coupon': coupon,
      'orderNumber': orderNumber,
      'status': status,
      'pickupMode': pickupMode,
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'serviceFee': serviceFee,
      'totalAmount': totalAmount,
      'specialInstructions': specialInstructions,
      'cancelledAt': cancelledAt,
      'cancellationReason': cancellationReason,
      'items': items?.map((item) => item.toJson()).toList(),
      'statusLogs': statusLogs,
      'disputes': disputes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class RejectOrderModelDataItemsItem {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  int? unitPrice;
  int? totalPrice;
  String? productName;
  String? createdAt;

  RejectOrderModelDataItemsItem({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.productName,
    this.createdAt,
  });

  factory RejectOrderModelDataItemsItem.fromJson(Map<String, dynamic> json) {
    return RejectOrderModelDataItemsItem(
      id: _asInt(json['id']),
      orderId: _asInt(json['orderId']),
      productId: _asInt(json['productId']),
      quantity: _asInt(json['quantity']),
      unitPrice: _asInt(json['unitPrice']),
      totalPrice: _asInt(json['totalPrice']),
      productName: _asString(json['productName']),
      createdAt: _asString(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'productName': productName,
      'createdAt': createdAt,
    };
  }
}

class RejectOrderModelDataStore {
  int? id;
  String? name;
  String? slug;
  String? phone;

  RejectOrderModelDataStore({
    this.id,
    this.name,
    this.slug,
    this.phone,
  });

  factory RejectOrderModelDataStore.fromJson(Map<String, dynamic> json) {
    return RejectOrderModelDataStore(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      phone: _asString(json['phone']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'phone': phone,
    };
  }
}

class RejectOrderModelDataCustomer {
  int? id;
  String? name;
  String? email;

  RejectOrderModelDataCustomer({
    this.id,
    this.name,
    this.email,
  });

  factory RejectOrderModelDataCustomer.fromJson(Map<String, dynamic> json) {
    return RejectOrderModelDataCustomer(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
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