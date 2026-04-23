CourierHandoverModel courierHandoverModelFromJson(dynamic json) {
  if (json == null) return CourierHandoverModel();
  if (json is Map<String, dynamic>) {
    return CourierHandoverModel.fromJson(json);
  }
  if (json is Map) {
    return CourierHandoverModel.fromJson(Map<String, dynamic>.from(json));
  }
  return CourierHandoverModel();
}

class CourierHandoverModel {
  CourierHandoverModel();

  factory CourierHandoverModel.fromJson(Map<String, dynamic> json) {
    return CourierHandoverModel();
  }
}
