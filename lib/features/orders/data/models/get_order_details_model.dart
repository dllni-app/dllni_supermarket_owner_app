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

GetOrderDetailsModel getOrderDetailsModelFromJson(str) =>
    GetOrderDetailsModel.fromJson(str);

String getOrderDetailsModelToJson(GetOrderDetailsModel data) =>
    json.encode(data.toJson());

GetOrderDetailsModelData getOrderDetailsModelDataFromJson(str) =>
    GetOrderDetailsModelData.fromJson(str);

String getOrderDetailsModelDataToJson(GetOrderDetailsModelData data) =>
    json.encode(data.toJson());

GetOrderDetailsModelDataItemsItem getOrderDetailsModelDataItemsItemFromJson(
  str,
) => GetOrderDetailsModelDataItemsItem.fromJson(str);

String getOrderDetailsModelDataItemsItemToJson(
  GetOrderDetailsModelDataItemsItem data,
) => json.encode(data.toJson());

GetOrderDetailsModelDataItemsItemProduct
getOrderDetailsModelDataItemsItemProductFromJson(str) =>
    GetOrderDetailsModelDataItemsItemProduct.fromJson(str);

String getOrderDetailsModelDataItemsItemProductToJson(
  GetOrderDetailsModelDataItemsItemProduct data,
) => json.encode(data.toJson());

GetOrderDetailsModelDataStore getOrderDetailsModelDataStoreFromJson(str) =>
    GetOrderDetailsModelDataStore.fromJson(str);

String getOrderDetailsModelDataStoreToJson(
  GetOrderDetailsModelDataStore data,
) => json.encode(data.toJson());

GetOrderDetailsModelDataCustomer getOrderDetailsModelDataCustomerFromJson(
  str,
) => GetOrderDetailsModelDataCustomer.fromJson(str);

String getOrderDetailsModelDataCustomerToJson(
  GetOrderDetailsModelDataCustomer data,
) => json.encode(data.toJson());

class GetOrderDetailsModel {
  GetOrderDetailsModelData? data;

  GetOrderDetailsModel({this.data});

  factory GetOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return GetOrderDetailsModel(
      data: json['data'] is Map
          ? GetOrderDetailsModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class GetOrderDetailsModelData {
  int? id;
  int? customerId;
  GetOrderDetailsModelDataCustomer? customer;
  int? storeId;
  GetOrderDetailsModelDataStore? store;
  dynamic couponId;
  dynamic coupon;
  int? cancellationPolicyId;
  String? orderNumber;
  String? status;
  String? pickupMode;
  dynamic pickupScheduledFor;
  String? readyForPickupAt;
  dynamic pickedUpAt;
  dynamic customerPickupConfirmedAt;
  String? subtotal;
  String? discountAmount;
  String? serviceFee;
  String? totalAmount;
  dynamic cancellationFeeAmount;
  dynamic cancellationPolicySnapshot;
  dynamic specialInstructions;
  dynamic cancelledAt;
  dynamic cancellationReason;
  OrderDetails? orderDetails;
  List<GetOrderDetailsModelDataItemsItem>? items;
  List<dynamic>? statusLogs;
  List<dynamic>? disputes;
  String? createdAt;
  String? updatedAt;

  GetOrderDetailsModelData({
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
    this.orderDetails,
  });

  factory GetOrderDetailsModelData.fromJson(Map<String, dynamic> json) {
    return GetOrderDetailsModelData(
      id: _asInt(json['id']),  
      customerId: _asInt(json['customerId']),
      customer: json['customer'] is Map
          ? GetOrderDetailsModelDataCustomer.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map),
            )
          : null,
      storeId: _asInt(json['storeId']),
      store: json['store'] is Map
          ? GetOrderDetailsModelDataStore.fromJson(
              Map<String, dynamic>.from(json['store'] as Map),
            )
          : null,
      couponId: _asDynamic(json['couponId']),
      coupon: _asDynamic(json['coupon']),
      cancellationPolicyId: _asInt(json['cancellationPolicyId']),
      orderNumber: _asString(json['orderNumber']),
      status: _asString(json['status']),
      pickupMode: _asString(json['pickupMode']),
      pickupScheduledFor: _asDynamic(json['pickupScheduledFor']),
      readyForPickupAt: _asString(json['readyForPickupAt']),
      pickedUpAt: _asDynamic(json['pickedUpAt']),
      customerPickupConfirmedAt: _asDynamic(json['customerPickupConfirmedAt']),
      subtotal: _asString(json['subtotal']),
      discountAmount: _asString(json['discountAmount']),
      serviceFee: _asString(json['serviceFee']),
      totalAmount: _asString(json['totalAmount']),
      cancellationFeeAmount: _asDynamic(json['cancellationFeeAmount']),
      cancellationPolicySnapshot: _asDynamic(
        json['cancellationPolicySnapshot'],
      ),
      specialInstructions: _asDynamic(json['specialInstructions']),
      cancelledAt: _asDynamic(json['cancelledAt']),
      cancellationReason: _asDynamic(json['cancellationReason']),
      items: json['items'] is List
          ? (json['items'] as List)
                .whereType<Map>()
                .map(
                  (item) => GetOrderDetailsModelDataItemsItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : null,
      statusLogs: _asDynamicList(json['statusLogs']),
      disputes: _asDynamicList(json['disputes']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
      orderDetails: json['orderDetails'] is Map
          ? OrderDetails.fromJson(
              Map<String, dynamic>.from(json['orderDetails'] as Map),
            )
          : null,
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
      'items': items?.map((item) => item.toJson()).toList(),
      'statusLogs': statusLogs,
      'disputes': disputes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class OrderDetails {
  String? currentStatus;
  String? currentStatusLabel;
  String? statusStartedAt;
  int? statusElapsedMinutes;
  String? statusElapsedText;
  String? expectedDeliveryAt;
  String? expectedDeliveryTime;
  String? deliveredAt;
  String? deliveredTime;
  int? deliveryDurationMinutes;
  String? deliveryDurationText;

  OrderDetails({
    this.currentStatus,
    this.currentStatusLabel,
    this.statusStartedAt,
    this.statusElapsedMinutes,
    this.statusElapsedText,
    this.expectedDeliveryAt,
    this.expectedDeliveryTime,
    this.deliveredAt,
    this.deliveredTime,
    this.deliveryDurationMinutes,
    this.deliveryDurationText,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      currentStatus: _asString(json['currentStatus']),
      currentStatusLabel: _asString(json['currentStatusLabel']),
      statusStartedAt: _asString(json['statusStartedAt']),
      statusElapsedMinutes: _asInt(json['statusElapsedMinutes']),
      statusElapsedText: _asString(json['statusElapsedText']),
      expectedDeliveryAt: _asString(json['expectedDeliveryAt']),
      expectedDeliveryTime: _asString(json['expectedDeliveryTime']),
      deliveredAt: _asString(json['deliveredAt']),
      deliveredTime: _asString(json['deliveredTime']),
      deliveryDurationMinutes: _asInt(json['deliveryDurationMinutes']),
      deliveryDurationText: _asString(json['deliveryDurationText']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStatus': currentStatus,
      'currentStatusLabel': currentStatusLabel,
      'statusStartedAt': statusStartedAt,
    };
  }
}

class GetOrderDetailsModelDataItemsItem {
  int? id;
  int? orderId;
  int? productId;
  GetOrderDetailsModelDataItemsItemProduct? product;
  int? quantity;
  String? unitPrice;
  String? totalPrice;
  String? productName;
  String? createdAt;
  String? updatedAt;

  GetOrderDetailsModelDataItemsItem({
    this.id,
    this.orderId,
    this.productId,
    this.product,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.productName,
    this.createdAt,
    this.updatedAt,
  });

  factory GetOrderDetailsModelDataItemsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetOrderDetailsModelDataItemsItem(
      id: _asInt(json['id']),
      orderId: _asInt(json['orderId']),
      productId: _asInt(json['productId']),
      product: json['product'] is Map
          ? GetOrderDetailsModelDataItemsItemProduct.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,
      quantity: _asInt(json['quantity']),
      unitPrice: _asString(json['unitPrice']),
      totalPrice: _asString(json['totalPrice']),
      productName: _asString(json['productName']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'product': product?.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'productName': productName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class GetOrderDetailsModelDataItemsItemProduct {
  int? id;
  int? storeId;
  int? categoryId;
  int? masterProductId;
  String? name;
  dynamic barcode;
  String? sourceType;
  dynamic description;
  String? price;
  String? discountedPrice;
  dynamic image;
  dynamic imageUrl;
  List<dynamic>? images;
  List<dynamic>? imageUrls;
  int? stockQuantity;
  int? lowStockThreshold;
  dynamic expiresAt;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;

  GetOrderDetailsModelDataItemsItemProduct({
    this.id,
    this.storeId,
    this.categoryId,
    this.masterProductId,
    this.name,
    this.barcode,
    this.sourceType,
    this.description,
    this.price,
    this.discountedPrice,
    this.image,
    this.imageUrl,
    this.images,
    this.imageUrls,
    this.stockQuantity,
    this.lowStockThreshold,
    this.expiresAt,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory GetOrderDetailsModelDataItemsItemProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetOrderDetailsModelDataItemsItemProduct(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      categoryId: _asInt(json['categoryId']),
      masterProductId: _asInt(json['masterProductId']),
      name: _asString(json['name']),
      barcode: _asDynamic(json['barcode']),
      sourceType: _asString(json['sourceType']),
      description: _asDynamic(json['description']),
      price: _asString(json['price']),
      discountedPrice: _asString(json['discountedPrice']),
      image: _asDynamic(json['image']),
      imageUrl: _asDynamic(json['imageUrl']),
      images: _asDynamicList(json['images']),
      imageUrls: _asDynamicList(json['imageUrls']),
      stockQuantity: _asInt(json['stockQuantity']),
      lowStockThreshold: _asInt(json['lowStockThreshold']),
      expiresAt: _asDynamic(json['expiresAt']),
      isAvailable: _asBool(json['isAvailable']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'categoryId': categoryId,
      'masterProductId': masterProductId,
      'name': name,
      'barcode': barcode,
      'sourceType': sourceType,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'image': image,
      'imageUrl': imageUrl,
      'images': images,
      'imageUrls': imageUrls,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'expiresAt': expiresAt,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class GetOrderDetailsModelDataStore {
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

  GetOrderDetailsModelDataStore({
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

  factory GetOrderDetailsModelDataStore.fromJson(Map<String, dynamic> json) {
    return GetOrderDetailsModelDataStore(
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

class GetOrderDetailsModelDataCustomer {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  dynamic moduleType;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  GetOrderDetailsModelDataCustomer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.moduleType,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GetOrderDetailsModelDataCustomer.fromJson(Map<String, dynamic> json) {
    return GetOrderDetailsModelDataCustomer(
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
