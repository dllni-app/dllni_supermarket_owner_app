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

GetHourlyCountModel getHourlyCountModelFromJson(str) =>
    GetHourlyCountModel.fromJson(str);

String getHourlyCountModelToJson(GetHourlyCountModel data) =>
    json.encode(data.toJson());

GetHourlyCountModelData getHourlyCountModelDataFromJson(str) =>
    GetHourlyCountModelData.fromJson(str);

String getHourlyCountModelDataToJson(GetHourlyCountModelData data) =>
    json.encode(data.toJson());

GetHourlyCountModelDataItem getHourlyCountModelDataFridayFromJson(str) =>
    GetHourlyCountModelDataItem.fromJson(str);

String getHourlyCountModelDataFridayToJson(GetHourlyCountModelDataItem data) =>
    json.encode(data.toJson());

GetHourlyCountModelDataThursday getHourlyCountModelDataThursdayFromJson(str) =>
    GetHourlyCountModelDataThursday.fromJson(str);

String getHourlyCountModelDataThursdayToJson(
  GetHourlyCountModelDataThursday data,
) => json.encode(data.toJson());

GetHourlyCountModelDataWednesday getHourlyCountModelDataWednesdayFromJson(
  str,
) => GetHourlyCountModelDataWednesday.fromJson(str);

String getHourlyCountModelDataWednesdayToJson(
  GetHourlyCountModelDataWednesday data,
) => json.encode(data.toJson());

GetHourlyCountModelDataTuesday getHourlyCountModelDataTuesdayFromJson(str) =>
    GetHourlyCountModelDataTuesday.fromJson(str);

String getHourlyCountModelDataTuesdayToJson(
  GetHourlyCountModelDataTuesday data,
) => json.encode(data.toJson());

GetHourlyCountModelDataMonday getHourlyCountModelDataMondayFromJson(str) =>
    GetHourlyCountModelDataMonday.fromJson(str);

String getHourlyCountModelDataMondayToJson(
  GetHourlyCountModelDataMonday data,
) => json.encode(data.toJson());

GetHourlyCountModelDataSunday getHourlyCountModelDataSundayFromJson(str) =>
    GetHourlyCountModelDataSunday.fromJson(str);

String getHourlyCountModelDataSundayToJson(
  GetHourlyCountModelDataSunday data,
) => json.encode(data.toJson());

GetHourlyCountModelDataSaturday getHourlyCountModelDataSaturdayFromJson(str) =>
    GetHourlyCountModelDataSaturday.fromJson(str);

String getHourlyCountModelDataSaturdayToJson(
  GetHourlyCountModelDataSaturday data,
) => json.encode(data.toJson());

class GetHourlyCountModel {
  GetHourlyCountModelData? data;

  GetHourlyCountModel({this.data});

  factory GetHourlyCountModel.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModel(
      data: json['data'] is Map
          ? GetHourlyCountModelData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.toJson()};
  }
}

class GetHourlyCountModelData {
  GetHourlyCountModelDataItem? saturday;
  GetHourlyCountModelDataItem? sunday;
  GetHourlyCountModelDataItem? monday;
  GetHourlyCountModelDataItem? tuesday;
  GetHourlyCountModelDataItem? wednesday;
  GetHourlyCountModelDataItem? thursday;
  GetHourlyCountModelDataItem? friday;

  GetHourlyCountModelData({
    this.saturday,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
  });

  factory GetHourlyCountModelData.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelData(
      saturday: json['saturday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['saturday'] as Map),
            )
          : null,
      sunday: json['sunday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['sunday'] as Map),
            )
          : null,
      monday: json['monday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['monday'] as Map),
            )
          : null,
      tuesday: json['tuesday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['tuesday'] as Map),
            )
          : null,
      wednesday: json['wednesday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['wednesday'] as Map),
            )
          : null,
      thursday: json['thursday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
              Map<String, dynamic>.from(json['thursday'] as Map),
            )
          : null,
      friday: json['friday'] is Map
          ? GetHourlyCountModelDataItem.fromJson(
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

class GetHourlyCountModelDataItem {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataItem({this.pending, this.preparing, this.completed});

  factory GetHourlyCountModelDataItem.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataItem(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetHourlyCountModelDataThursday {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataThursday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetHourlyCountModelDataThursday.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataThursday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetHourlyCountModelDataWednesday {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataWednesday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetHourlyCountModelDataWednesday.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataWednesday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetHourlyCountModelDataTuesday {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataTuesday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetHourlyCountModelDataTuesday.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataTuesday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetHourlyCountModelDataMonday {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataMonday({this.pending, this.preparing, this.completed});

  factory GetHourlyCountModelDataMonday.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataMonday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetHourlyCountModelDataSunday {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataSunday({this.pending, this.preparing, this.completed});

  factory GetHourlyCountModelDataSunday.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataSunday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}

class GetHourlyCountModelDataSaturday {
  int? pending;
  int? preparing;
  int? completed;

  GetHourlyCountModelDataSaturday({
    this.pending,
    this.preparing,
    this.completed,
  });

  factory GetHourlyCountModelDataSaturday.fromJson(Map<String, dynamic> json) {
    return GetHourlyCountModelDataSaturday(
      pending: _asInt(json['pending']),
      preparing: _asInt(json['preparing']),
      completed: _asInt(json['completed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending': pending, 'preparing': preparing, 'completed': completed};
  }
}
