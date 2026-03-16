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

GetStoreEmployeesModel getStoreEmployeesModelFromJson(str) =>
    GetStoreEmployeesModel.fromJson(str);

String getStoreEmployeesModelToJson(GetStoreEmployeesModel data) =>
    json.encode(data.toJson());

GetStoreEmployeesModelData getStoreEmployeesModelDataFromJson(str) =>
    GetStoreEmployeesModelData.fromJson(str);

String getStoreEmployeesModelDataToJson(GetStoreEmployeesModelData data) =>
    json.encode(data.toJson());

GetStoreEmployeesModelDataEmployeesItem
getStoreEmployeesModelDataEmployeesItemFromJson(str) =>
    GetStoreEmployeesModelDataEmployeesItem.fromJson(str);

String getStoreEmployeesModelDataEmployeesItemToJson(
  GetStoreEmployeesModelDataEmployeesItem data,
) => json.encode(data.toJson());

GetStoreEmployeesModelDataEmployeesItemUser
getStoreEmployeesModelDataEmployeesItemUserFromJson(str) =>
    GetStoreEmployeesModelDataEmployeesItemUser.fromJson(str);

String getStoreEmployeesModelDataEmployeesItemUserToJson(
  GetStoreEmployeesModelDataEmployeesItemUser data,
) => json.encode(data.toJson());

class GetStoreEmployeesModel {
  GetStoreEmployeesModelData? data;

  GetStoreEmployeesModel({this.data});

  factory GetStoreEmployeesModel.fromJson(Map<String, dynamic> json) {
    return GetStoreEmployeesModel(
      data: json['data'] is Map
          ? GetStoreEmployeesModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class GetStoreEmployeesModelData {
  List<GetStoreEmployeesModelDataEmployeesItem>? employees;

  GetStoreEmployeesModelData({this.employees});

  factory GetStoreEmployeesModelData.fromJson(Map<String, dynamic> json) {
    return GetStoreEmployeesModelData(
      employees: json['employees'] is List
          ? (json['employees'] as List)
                .whereType<Map>()
                .map(
                  (item) => GetStoreEmployeesModelDataEmployeesItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'employees': employees?.map((item) => item.toJson()).toList()};
  }
}

class GetStoreEmployeesModelDataEmployeesItem {
  int? id;
  int? storeId;
  int? userId;
  bool? isActive;
  GetStoreEmployeesModelDataEmployeesItemUser? user;
  List<int>? permissionIds;
  List<String>? effectivePermissions;
  String? createdAt;
  String? updatedAt;

  GetStoreEmployeesModelDataEmployeesItem({
    this.id,
    this.storeId,
    this.userId,
    this.isActive,
    this.user,
    this.permissionIds,
    this.effectivePermissions,
    this.createdAt,
    this.updatedAt,
  });

  factory GetStoreEmployeesModelDataEmployeesItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetStoreEmployeesModelDataEmployeesItem(
      id: _asInt(json['id']),
      storeId: _asInt(json['storeId']),
      userId: _asInt(json['userId']),
      isActive: _asBool(json['isActive']),
      user: json['user'] is Map
          ? GetStoreEmployeesModelDataEmployeesItemUser.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            )
          : null,
      permissionIds: json['permissionIds'] is List
          ? (json['permissionIds'] as List)
                .map((item) => _asInt(item))
                .whereType<int>()
                .toList()
          : null,
      effectivePermissions: json['effectivePermissions'] is List
          ? (json['effectivePermissions'] as List)
                .map((item) => _asString(item))
                .whereType<String>()
                .toList()
          : null,
      createdAt: _asString(json['createdAt']),
      updatedAt: _asString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'userId': userId,
      'isActive': isActive,
      'user': user?.toJson(),
      'permissionIds': permissionIds,
      'effectivePermissions': effectivePermissions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class GetStoreEmployeesModelDataEmployeesItemUser {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? profileImageUrl;

  GetStoreEmployeesModelDataEmployeesItemUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImageUrl,
  });

  factory GetStoreEmployeesModelDataEmployeesItemUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetStoreEmployeesModelDataEmployeesItemUser(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      phone: _asString(json['phone']),
      profileImageUrl: _asString(json['profileImageUrl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }
}
