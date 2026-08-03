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

GetEmployeePermissionsModel getEmployeePermissionsModelFromJson(str) =>
    GetEmployeePermissionsModel.fromJson(str);

String getEmployeePermissionsModelToJson(
  GetEmployeePermissionsModel data,
) =>
    json.encode(data.toJson());

GetEmployeePermissionsModelData getEmployeePermissionsModelDataFromJson(str) =>
    GetEmployeePermissionsModelData.fromJson(str);

String getEmployeePermissionsModelDataToJson(
  GetEmployeePermissionsModelData data,
) =>
    json.encode(data.toJson());

GetEmployeePermissionsModelDataPermissionsItem
getEmployeePermissionsModelDataPermissionsItemFromJson(str) =>
    GetEmployeePermissionsModelDataPermissionsItem.fromJson(str);

String getEmployeePermissionsModelDataPermissionsItemToJson(
  GetEmployeePermissionsModelDataPermissionsItem data,
) =>
    json.encode(data.toJson());

class GetEmployeePermissionsModel {
  GetEmployeePermissionsModelData? data;

  GetEmployeePermissionsModel({this.data});

  factory GetEmployeePermissionsModel.fromJson(Map<String, dynamic> json) {
    return GetEmployeePermissionsModel(
      data: json['data'] is Map
          ? GetEmployeePermissionsModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class GetEmployeePermissionsModelData {
  List<GetEmployeePermissionsModelDataPermissionsItem>? permissions;

  GetEmployeePermissionsModelData({this.permissions});

  factory GetEmployeePermissionsModelData.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetEmployeePermissionsModelData(
      permissions: json['permissions'] is List
          ? (json['permissions'] as List)
              .whereType<Map>()
              .map(
                (item) =>
                    GetEmployeePermissionsModelDataPermissionsItem.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
              )
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permissions': permissions?.map((item) => item.toJson()).toList(),
    };
  }
}

class GetEmployeePermissionsModelDataPermissionsItem {
  int? id;
  String? name;
  String? code;
  String? slug;
  String? description;
  String? group;

  GetEmployeePermissionsModelDataPermissionsItem({
    this.id,
    this.name,
    this.code,
    this.slug,
    this.description,
    this.group,
  });

  factory GetEmployeePermissionsModelDataPermissionsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final code = _asString(json['name']);
    final slug = _asString(json['slug']);

    return GetEmployeePermissionsModelDataPermissionsItem(
      id: _asInt(json['id']),
      name: slug ?? code,
      code: code,
      slug: slug,
      description: _asString(json['description']),
      group: _asString(json['group']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': code ?? name,
      'slug': slug,
      'description': description,
      'group': group,
    };
  }
}
