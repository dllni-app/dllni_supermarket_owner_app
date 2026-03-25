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

AddCouponCodeModel addCouponCodeModelFromJson(str) => AddCouponCodeModel.fromJson(str);

String addCouponCodeModelToJson(AddCouponCodeModel data) => json.encode(data.toJson());


AddCouponCodeModelData addCouponCodeModelDataFromJson(str) => AddCouponCodeModelData.fromJson(str);

String addCouponCodeModelDataToJson(AddCouponCodeModelData data) => json.encode(data.toJson());


AddCouponCodeModelDataStore addCouponCodeModelDataStoreFromJson(str) => AddCouponCodeModelDataStore.fromJson(str);

String addCouponCodeModelDataStoreToJson(AddCouponCodeModelDataStore data) => json.encode(data.toJson());


class AddCouponCodeModel {
  AddCouponCodeModelData? data;

  AddCouponCodeModel({
    this.data,
  });

  factory AddCouponCodeModel.fromJson(Map<String, dynamic> json) {
    return AddCouponCodeModel(
      data: json['data'] is Map ? AddCouponCodeModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class AddCouponCodeModelData {
  int? id;
  int? storeId;
  AddCouponCodeModelDataStore? store;
  String? code;
  String? type;
  String? value;
  int? percent;
  String? minOrderAmount;
  String? maxDiscountAmount;
  int? usageLimit;
  int? usedCount;
  String? startsAt;
  String? endsAt;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  AddCouponCodeModelData({
    this.id,
    this.storeId,
    this.store,
    this.code,
    this.type,
    this.value,
    this.percent,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.usageLimit,
    this.usedCount,
    this.startsAt,
    this.endsAt,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AddCouponCodeModelData.fromJson(Map<String, dynamic> json) {
    return AddCouponCodeModelData(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      store: json['store'] is Map ? AddCouponCodeModelDataStore.fromJson(Map<String, dynamic>.from(json['store'] as Map)) : null,
      code: _asString(json['code']),
      type: _asString(json['type']),
      value: _asString(json['value']),
      percent: _asInt(json['percent']),
      minOrderAmount: _asString(json['minOrderAmount']),
      maxDiscountAmount: _asString(json['maxDiscountAmount']),
      usageLimit: _asInt(json['usageLimit']),
      usedCount: _asInt(json['usedCount']),
      startsAt: _asString(json['startsAt']),
      endsAt: _asString(json['endsAt']),
      isActive: _asBool(json['isActive']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'store': store?.toJson(),
      'code': code,
      'type': type,
      'value': value,
      'percent': percent,
      'minOrderAmount': minOrderAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'startsAt': startsAt,
      'endsAt': endsAt,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class AddCouponCodeModelDataStore {
  int? id;
  int? ownerUserId;
  String? name;
  String? slug;
  String? description;
  String? address;
  dynamic city;
  dynamic neighborhood;
  String? latitude;
  String? longitude;
  String? phone;
  String? email;
  dynamic cover;
  dynamic logo;
  String? averageRating;
  int? totalReviews;
  int? trustScore;
  int? warningCount;
  bool? isActive;
  bool? isFeatured;
  dynamic suspensionUntil;
  String? createdAt;
  String? updatedAt;

  AddCouponCodeModelDataStore({
    this.id,
    this.ownerUserId,
    this.name,
    this.slug,
    this.description,
    this.address,
    this.city,
    this.neighborhood,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.cover,
    this.logo,
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

  factory AddCouponCodeModelDataStore.fromJson(Map<String, dynamic> json) {
    return AddCouponCodeModelDataStore(
      id: _asInt(json['id']),
      ownerUserId: _asInt(json['ownerUserId']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      description: _asString(json['description']),
      address: _asString(json['address']),
      city: _asDynamic(json['city']),
      neighborhood: _asDynamic(json['neighborhood']),
      latitude: _asString(json['latitude']),
      longitude: _asString(json['longitude']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      cover: _asDynamic(json['cover']),
      logo: _asDynamic(json['logo']),
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
      'city': city,
      'neighborhood': neighborhood,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'cover': cover,
      'logo': logo,
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