import 'dart:convert';

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

UpdateStoreEmployeePasswordModel updateStoreEmployeePasswordModelFromJson(
  str,
) => UpdateStoreEmployeePasswordModel.fromJson(
  str is Map<String, dynamic> ? str : Map<String, dynamic>.from(str as Map),
);

String updateStoreEmployeePasswordModelToJson(
  UpdateStoreEmployeePasswordModel data,
) => json.encode(data.toJson());

class UpdateStoreEmployeePasswordModel {
  final String? message;

  UpdateStoreEmployeePasswordModel({this.message});

  factory UpdateStoreEmployeePasswordModel.fromJson(Map<String, dynamic> json) {
    return UpdateStoreEmployeePasswordModel(
      message: _asString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
