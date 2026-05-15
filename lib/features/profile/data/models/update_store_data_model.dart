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

UpdateStoreDataModel updateStoreDataModelFromJson(str) => UpdateStoreDataModel.fromJson(str);

String updateStoreDataModelToJson(UpdateStoreDataModel data) => json.encode(data.toJson());


UpdateStoreDataModelData updateStoreDataModelDataFromJson(str) => UpdateStoreDataModelData.fromJson(str);

String updateStoreDataModelDataToJson(UpdateStoreDataModelData data) => json.encode(data.toJson());


UpdateStoreDataModelDataOwner updateStoreDataModelDataOwnerFromJson(str) => UpdateStoreDataModelDataOwner.fromJson(str);

String updateStoreDataModelDataOwnerToJson(UpdateStoreDataModelDataOwner data) => json.encode(data.toJson());


class UpdateStoreDataModel {
  UpdateStoreDataModelData? data;

  UpdateStoreDataModel({
    this.data,
  });

  factory UpdateStoreDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateStoreDataModel(
      data: json['data'] is Map ? UpdateStoreDataModelData.fromJson(Map<String, dynamic>.from(json['data'] as Map)) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class UpdateStoreDataModelData {
  int? id;
  int? ownerUserId;
  UpdateStoreDataModelDataOwner? owner;
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
  String? cover;
  String? logo;
  String? averageRating;
  int? totalReviews;
  int? trustScore;
  int? warningCount;
  bool? isActive;
  bool? isFeatured;
  String? suspensionUntil;
  String? createdAt;
  String? updatedAt;

  UpdateStoreDataModelData({
    this.id,
    this.ownerUserId,
    this.owner,
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

  factory UpdateStoreDataModelData.fromJson(Map<String, dynamic> json) {
    return UpdateStoreDataModelData(
      id: _asInt(json['id']),
      ownerUserId: _asInt(json['ownerUserId']),
      owner: json['owner'] is Map ? UpdateStoreDataModelDataOwner.fromJson(Map<String, dynamic>.from(json['owner'] as Map)) : null,
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
      cover: _asString(json['cover']),
      logo: _asString(json['logo']),
      averageRating: _asString(json['averageRating']),
      totalReviews: _asInt(json['totalReviews']),
      trustScore: _asInt(json['trustScore']),
      warningCount: _asInt(json['warningCount']),
      isActive: _asBool(json['isActive']),
      isFeatured: _asBool(json['isFeatured']),
      suspensionUntil: _asString(json['suspensionUntil']),
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUserId': ownerUserId,
      'owner': owner?.toJson(),
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

class UpdateStoreDataModelDataOwner {
  int? id;
  String? name;
  String? email;
  dynamic phone;
  dynamic moduleType;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UpdateStoreDataModelDataOwner({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.moduleType,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateStoreDataModelDataOwner.fromJson(Map<String, dynamic> json) {
    return UpdateStoreDataModelDataOwner(
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