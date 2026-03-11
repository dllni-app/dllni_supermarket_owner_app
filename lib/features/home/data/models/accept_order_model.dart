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

AcceptOrderModel acceptOrderModelFromJson(str) => AcceptOrderModel.fromJson(str);

String acceptOrderModelToJson(AcceptOrderModel data) => json.encode(data.toJson());


AcceptOrderModelData acceptOrderModelDataFromJson(str) => AcceptOrderModelData.fromJson(str);

String acceptOrderModelDataToJson(AcceptOrderModelData data) => json.encode(data.toJson());


AcceptOrderModelDataStore acceptOrderModelDataStoreFromJson(str) => AcceptOrderModelDataStore.fromJson(str);

String acceptOrderModelDataStoreToJson(AcceptOrderModelDataStore data) => json.encode(data.toJson());


AcceptOrderModelDataCustomer acceptOrderModelDataCustomerFromJson(str) => AcceptOrderModelDataCustomer.fromJson(str);

String acceptOrderModelDataCustomerToJson(AcceptOrderModelDataCustomer data) => json.encode(data.toJson());


class AcceptOrderModel {
  AcceptOrderModelData? data;
  String? message;

  AcceptOrderModel({
    this.data,
    this.message,
  });

  factory AcceptOrderModel.fromJson(Map<String, dynamic> json) {
    return AcceptOrderModel(
      data: json['data'] is Map ? AcceptOrderModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
      message: _asString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class AcceptOrderModelData {
  int? id;
  int? customerId;
  AcceptOrderModelDataCustomer? customer;
  int? storeId;
  AcceptOrderModelDataStore? store;
  dynamic couponId;
  dynamic coupon;
  dynamic cancellationPolicyId;
  String? orderNumber;
  String? status;
  String? pickupMode;
  String? pickupScheduledFor;
  String? readyForPickupAt;
  String? pickedUpAt;
  String? customerPickupConfirmedAt;
  String? subtotal;
  String? discountAmount;
  String? serviceFee;
  String? totalAmount;
  dynamic cancellationFeeAmount;
  List<dynamic>? cancellationPolicySnapshot;
  String? specialInstructions;
  String? cancelledAt;
  String? cancellationReason;
  List<dynamic>? items;
  List<dynamic>? statusLogs;
  List<dynamic>? disputes;
  String? createdAt;
  String? updatedAt;

  AcceptOrderModelData({
    this.id,
    this.customerId,
    this.customer,
    this.storeId,
    this.store,
    this.couponId,
    this.coupon,
    this.cancellationPolicyId,
    this.orderNumber,
    this.status,
    this.pickupMode,
    this.pickupScheduledFor,
    this.readyForPickupAt,
    this.pickedUpAt,
    this.customerPickupConfirmedAt,
    this.subtotal,
    this.discountAmount,
    this.serviceFee,
    this.totalAmount,
    this.cancellationFeeAmount,
    this.cancellationPolicySnapshot,
    this.specialInstructions,
    this.cancelledAt,
    this.cancellationReason,
    this.items,
    this.statusLogs,
    this.disputes,
    this.createdAt,
    this.updatedAt,
  });

  factory AcceptOrderModelData.fromJson(Map<String, dynamic> json) {
    return AcceptOrderModelData(
      id: _asInt(json['id']),
      customerId: _asInt(json['customerId']),
      customer: json['customer'] is Map ? AcceptOrderModelDataCustomer.fromJson(Map<String, dynamic>.from(json['customer'] as Map)) : null,
      storeId: _asInt(json['storeId']),
      store: json['store'] is Map ? AcceptOrderModelDataStore.fromJson(Map<String, dynamic>.from(json['store'] as Map)) : null,
      couponId: _asDynamic(json['couponId']),
      coupon: _asDynamic(json['coupon']),
      cancellationPolicyId: _asDynamic(json['cancellationPolicyId']),
      orderNumber: _asString(json['orderNumber']),
      status: _asString(json['status']),
      pickupMode: _asString(json['pickupMode']),
      pickupScheduledFor: _asString(json['pickupScheduledFor']),
      readyForPickupAt: _asString(json['readyForPickupAt']),
      pickedUpAt: _asString(json['pickedUpAt']),
      customerPickupConfirmedAt: _asString(json['customerPickupConfirmedAt']),
      subtotal: _asString(json['subtotal']),
      discountAmount: _asString(json['discountAmount']),
      serviceFee: _asString(json['serviceFee']),
      totalAmount: _asString(json['totalAmount']),
      cancellationFeeAmount: _asDynamic(json['cancellationFeeAmount']),
      cancellationPolicySnapshot: _asDynamicList(json['cancellationPolicySnapshot']),
      specialInstructions: _asString(json['specialInstructions']),
      cancelledAt: _asString(json['cancelledAt']),
      cancellationReason: _asString(json['cancellationReason']),
      items: _asDynamicList(json['items']),
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
      'cancellationPolicyId': cancellationPolicyId,
      'orderNumber': orderNumber,
      'status': status,
      'pickupMode': pickupMode,
      'pickupScheduledFor': pickupScheduledFor,
      'readyForPickupAt': readyForPickupAt,
      'pickedUpAt': pickedUpAt,
      'customerPickupConfirmedAt': customerPickupConfirmedAt,
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'serviceFee': serviceFee,
      'totalAmount': totalAmount,
      'cancellationFeeAmount': cancellationFeeAmount,
      'cancellationPolicySnapshot': cancellationPolicySnapshot,
      'specialInstructions': specialInstructions,
      'cancelledAt': cancelledAt,
      'cancellationReason': cancellationReason,
      'items': items,
      'statusLogs': statusLogs,
      'disputes': disputes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class AcceptOrderModelDataStore {
  int? id;
  int? ownerUserId;
  String? name;
  String? slug;
  String? description;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  String? averageRating;
  int? totalReviews;
  int? trustScore;
  int? warningCount;
  bool? isActive;
  bool? isFeatured;
  dynamic suspensionUntil;
  String? createdAt;
  String? updatedAt;

  AcceptOrderModelDataStore({
    this.id,
    this.ownerUserId,
    this.name,
    this.slug,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.averageRating,
    this.totalReviews,
    this.trustScore,
    this.warningCount,
    this.isActive,
    this.isFeatured,
    this.suspensionUntil,
    this.createdAt,
    this.updatedAt,
  });

  factory AcceptOrderModelDataStore.fromJson(Map<String, dynamic> json) {
    return AcceptOrderModelDataStore(
      id: _asInt(json['id']),
      ownerUserId: _asInt(json['ownerUserId']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      description: _asString(json['description']),
      address: _asString(json['address']),
      latitude: _asString(json['latitude']),
      longitude: _asString(json['longitude']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      averageRating: _asString(json['averageRating']),
      totalReviews: _asInt(json['totalReviews']),
      trustScore: _asInt(json['trustScore']),
      warningCount: _asInt(json['warningCount']),
      isActive: _asBool(json['isActive']),
      isFeatured: _asBool(json['isFeatured']),
      suspensionUntil: _asDynamic(json['suspensionUntil']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUserId': ownerUserId,
      'name': name,
      'slug': slug,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'trustScore': trustScore,
      'warningCount': warningCount,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'suspensionUntil': suspensionUntil,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class AcceptOrderModelDataCustomer {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  dynamic moduleType;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  AcceptOrderModelDataCustomer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.moduleType,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AcceptOrderModelDataCustomer.fromJson(Map<String, dynamic> json) {
    return AcceptOrderModelDataCustomer(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      phone: _asDynamic(json['phone']),
      moduleType: _asDynamic(json['moduleType']),
      emailVerifiedAt: _asString(json['emailVerifiedAt']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'moduleType': moduleType,
      'emailVerifiedAt': emailVerifiedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}