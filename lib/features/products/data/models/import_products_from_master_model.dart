import 'dart:convert';

ImportProductsFromMasterModel importProductsFromMasterModelFromJson(
  dynamic str,
) => ImportProductsFromMasterModel.fromJson(
  str is Map<String, dynamic> ? str : <String, dynamic>{},
);

String importProductsFromMasterModelToJson(ImportProductsFromMasterModel data) =>
    json.encode(data.toJson());

class ImportProductsFromMasterModel {
  ImportProductsFromMasterModel();

  factory ImportProductsFromMasterModel.fromJson(Map<String, dynamic> json) {
    return ImportProductsFromMasterModel();
  }

  Map<String, dynamic> toJson() => {};
}
