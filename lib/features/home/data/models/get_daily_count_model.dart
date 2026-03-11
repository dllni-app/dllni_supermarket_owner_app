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

GetDailyCountModel getDailyCountModelFromJson(str) =>
    GetDailyCountModel.fromJson(str);

String getDailyCountModelToJson(GetDailyCountModel data) =>
    json.encode(data.toJson());

GetDailyCountModelData getDailyCountModelDataFromJson(str) =>
    GetDailyCountModelData.fromJson(str);

String getDailyCountModelDataToJson(GetDailyCountModelData data) =>
    json.encode(data.toJson());

GetDailyCountModelDataItem getDailyCountModelDataFridayFromJson(str) =>
    GetDailyCountModelDataItem.fromJson(str);

String getDailyCountModelDataFridayToJson(GetDailyCountModelDataItem data) =>
    json.encode(data.toJson());

GetDailyCountModelDataThursday getDailyCountModelDataThursdayFromJson(str) =>
    GetDailyCountModelDataThursday.fromJson(str);

String getDailyCountModelDataThursdayToJson(
  GetDailyCountModelDataThursday data,
) => json.encode(data.toJson());

GetDailyCountModelDataWednesday getDailyCountModelDataWednesdayFromJson(str) =>
    GetDailyCountModelDataWednesday.fromJson(str);

String getDailyCountModelDataWednesdayToJson(
  GetDailyCountModelDataWednesday data,
) => json.encode(data.toJson());

GetDailyCountModelDataTuesday getDailyCountModelDataTuesdayFromJson(str) =>
    GetDailyCountModelDataTuesday.fromJson(str);

String getDailyCountModelDataTuesdayToJson(
  GetDailyCountModelDataTuesday data,
) => json.encode(data.toJson());

GetDailyCountModelDataMonday getDailyCountModelDataMondayFromJson(str) =>
    GetDailyCountModelDataMonday.fromJson(str);

String getDailyCountModelDataMondayToJson(GetDailyCountModelDataMonday data) =>
    json.encode(data.toJson());

GetDailyCountModelDataSunday getDailyCountModelDataSundayFromJson(str) =>
    GetDailyCountModelDataSunday.fromJson(str);

String getDailyCountModelDataSundayToJson(GetDailyCountModelDataSunday data) =>
    json.encode(data.toJson());

GetDailyCountModelDataSaturday getDailyCountModelDataSaturdayFromJson(str) =>
    GetDailyCountModelDataSaturday.fromJson(str);

String getDailyCountModelDataSaturdayToJson(
  GetDailyCountModelDataSaturday data,
) => json.encode(data.toJson());

class GetDailyCountModel {
  GetDailyCountModelData? data;

  GetDailyCountModel({this.data});

  factory GetDailyCountModel.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModel(
      data: json['data'] is Map
          ? GetDailyCountModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class GetDailyCountModelData {
  GetDailyCountModelDataItem? saturday;
  GetDailyCountModelDataItem? sunday;
  GetDailyCountModelDataItem? monday;
  GetDailyCountModelDataItem? tuesday;
  GetDailyCountModelDataItem? wednesday;
  GetDailyCountModelDataItem? thursday;
  GetDailyCountModelDataItem? friday;

  GetDailyCountModelData({
    this.saturday,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
  });

  factory GetDailyCountModelData.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelData(
      saturday: json['saturday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['saturday'] as Map),
            )
          : null,
      sunday: json['sunday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['sunday'] as Map),
            )
          : null,
      monday: json['monday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['monday'] as Map),
            )
          : null,
      tuesday: json['tuesday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['tuesday'] as Map),
            )
          : null,
      wednesday: json['wednesday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['wednesday'] as Map),
            )
          : null,
      thursday: json['thursday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['thursday'] as Map),
            )
          : null,
      friday: json['friday'] is Map
          ? GetDailyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['friday'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saturday': saturday?.toJson(),
      'sunday': sunday?.toJson(),
      'monday': monday?.toJson(),
      'tuesday': tuesday?.toJson(),
      'wednesday': wednesday?.toJson(),
      'thursday': thursday?.toJson(),
      'friday': friday?.toJson(),
    };
  }
}

class GetDailyCountModelDataItem {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataItem({this.pending, this.preparing, this.completed});

  factory GetDailyCountModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataItem(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetDailyCountModelDataThursday {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataThursday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetDailyCountModelDataThursday.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataThursday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetDailyCountModelDataWednesday {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataWednesday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetDailyCountModelDataWednesday.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataWednesday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetDailyCountModelDataTuesday {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataTuesday({this.pending, this.preparing, this.completed});

  factory GetDailyCountModelDataTuesday.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataTuesday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetDailyCountModelDataMonday {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataMonday({this.pending, this.preparing, this.completed});

  factory GetDailyCountModelDataMonday.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataMonday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetDailyCountModelDataSunday {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataSunday({this.pending, this.preparing, this.completed});

  factory GetDailyCountModelDataSunday.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataSunday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetDailyCountModelDataSaturday {
  int? pending;
  int? preparing;
  int? completed;

  GetDailyCountModelDataSaturday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetDailyCountModelDataSaturday.fromJson(Map<String, dynamic> json) {
    return GetDailyCountModelDataSaturday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}
