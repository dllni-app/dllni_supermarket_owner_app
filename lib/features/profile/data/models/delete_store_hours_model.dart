class DeleteStoreHoursModel {
  String? message;
  DeleteStoreHoursModel({this.message});

  factory DeleteStoreHoursModel.fromJson(dynamic message) {
    return DeleteStoreHoursModel(message: message.toString());
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
