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

GetPreparingOrdersModel getPreparingOrdersModelFromJson(str) => GetPreparingOrdersModel.fromJson(str);

String getPreparingOrdersModelToJson(GetPreparingOrdersModel data) => json.encode(data.toJson());


GetPreparingOrdersModelMeta getPreparingOrdersModelMetaFromJson(str) => GetPreparingOrdersModelMeta.fromJson(str);

String getPreparingOrdersModelMetaToJson(GetPreparingOrdersModelMeta data) => json.encode(data.toJson());


GetPreparingOrdersModelMetaLinksItem getPreparingOrdersModelMetaLinksItemFromJson(str) => GetPreparingOrdersModelMetaLinksItem.fromJson(str);

String getPreparingOrdersModelMetaLinksItemToJson(GetPreparingOrdersModelMetaLinksItem data) => json.encode(data.toJson());


GetPreparingOrdersModelLinks getPreparingOrdersModelLinksFromJson(str) => GetPreparingOrdersModelLinks.fromJson(str);

String getPreparingOrdersModelLinksToJson(GetPreparingOrdersModelLinks data) => json.encode(data.toJson());


GetPreparingOrdersModelDataItem getPreparingOrdersModelDataItemFromJson(str) => GetPreparingOrdersModelDataItem.fromJson(str);

String getPreparingOrdersModelDataItemToJson(GetPreparingOrdersModelDataItem data) => json.encode(data.toJson());


class GetPreparingOrdersModel {
  List<GetPreparingOrdersModelDataItem>? data;
  GetPreparingOrdersModelLinks? links;
  GetPreparingOrdersModelMeta? meta;

  GetPreparingOrdersModel({
    this.data,
    this.links,
    this.meta,
  });

  factory GetPreparingOrdersModel.fromJson(Map<String, dynamic> json) {
    return GetPreparingOrdersModel(
      data: json['data'] is List ? (json['data'] as List).whereType<Map>().map((item) => GetPreparingOrdersModelDataItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      links: json['links'] is Map ? GetPreparingOrdersModelLinks.fromJson(Map<String, dynamic>.from(json['links'] as Map)) : null,
      meta: json['meta'] is Map ? GetPreparingOrdersModelMeta.fromJson(Map<String, dynamic>.from(json['meta'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
      'links': links?.toJson(),
      'meta': meta?.toJson(),
    };
  }
}

class GetPreparingOrdersModelMeta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<GetPreparingOrdersModelMetaLinksItem>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  GetPreparingOrdersModelMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory GetPreparingOrdersModelMeta.fromJson(Map<String, dynamic> json) {
    return GetPreparingOrdersModelMeta(
      currentPage: _asInt(json['current_page']),
      from: _asInt(json['from']),
      lastPage: _asInt(json['last_page']),
      links: json['links'] is List ? (json['links'] as List).whereType<Map>().map((item) => GetPreparingOrdersModelMetaLinksItem.fromJson(Map<String, dynamic>.from(item))).toList() : null,
      path: _asString(json['path']),
      perPage: _asInt(json['per_page']),
      to: _asInt(json['to']),
      total: _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links?.map((item) => item.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class GetPreparingOrdersModelMetaLinksItem {
  String? url;
  String? label;
  int? page;
  bool? active;

  GetPreparingOrdersModelMetaLinksItem({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory GetPreparingOrdersModelMetaLinksItem.fromJson(Map<String, dynamic> json) {
    return GetPreparingOrdersModelMetaLinksItem(
      url: _asString(json['url']),
      label: _asString(json['label']),
      page: _asInt(json['page']),
      active: _asBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}

class GetPreparingOrdersModelLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  GetPreparingOrdersModelLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory GetPreparingOrdersModelLinks.fromJson(Map<String, dynamic> json) {
    return GetPreparingOrdersModelLinks(
      first: _asString(json['first']),
      last: _asString(json['last']),
      prev: _asDynamic(json['prev']),
      next: _asDynamic(json['next']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

class GetPreparingOrdersModelDataItem {
  int? id;
  int? customerId;
  int? storeId;
  dynamic couponId;
  int? cancellationPolicyId;
  String? orderNumber;
  String? status;
  String? pickupMode;
  dynamic pickupScheduledFor;
  dynamic readyForPickupAt;
  dynamic pickedUpAt;
  dynamic customerPickupConfirmedAt;
  String? subtotal;
  String? discountAmount;
  String? serviceFee;
  String? totalAmount;
  dynamic cancellationFeeAmount;
  dynamic cancellationPolicySnapshot;
  String? specialInstructions;
  dynamic cancelledAt;
  dynamic cancellationReason;
  String? createdAt;
  String? updatedAt;

  GetPreparingOrdersModelDataItem({
    this.id,
    this.customerId,
    this.storeId,
    this.couponId,
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
    this.createdAt,
    this.updatedAt,
  });

  factory GetPreparingOrdersModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetPreparingOrdersModelDataItem(
      id: _asInt(json['id']),
      customerId: _asInt(json['customerId']),
      storeId: _asInt(json['storeId']),
      couponId: _asDynamic(json['couponId']),
      cancellationPolicyId: _asInt(json['cancellationPolicyId']),
      orderNumber: _asString(json['orderNumber']),
      status: _asString(json['status']),
      pickupMode: _asString(json['pickupMode']),
      pickupScheduledFor: _asDynamic(json['pickupScheduledFor']),
      readyForPickupAt: _asDynamic(json['readyForPickupAt']),
      pickedUpAt: _asDynamic(json['pickedUpAt']),
      customerPickupConfirmedAt: _asDynamic(json['customerPickupConfirmedAt']),
      subtotal: _asString(json['subtotal']),
      discountAmount: _asString(json['discountAmount']),
      serviceFee: _asString(json['serviceFee']),
      totalAmount: _asString(json['totalAmount']),
      cancellationFeeAmount: _asDynamic(json['cancellationFeeAmount']),
      cancellationPolicySnapshot: _asDynamic(json['cancellationPolicySnapshot']),
      specialInstructions: _asString(json['specialInstructions']),
      cancelledAt: _asDynamic(json['cancelledAt']),
      cancellationReason: _asDynamic(json['cancellationReason']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'storeId': storeId,
      'couponId': couponId,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}