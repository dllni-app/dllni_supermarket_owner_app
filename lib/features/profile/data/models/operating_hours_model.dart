import 'dart:convert';

import 'package:intl/intl.dart';

String? _asString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
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

/// Parses API times like `"08:00 AM"` to `HH:mm` for the app time picker.
String? apiTimeToHHmm(String? api) {
  if (api == null || api.trim().isEmpty) return null;
  final t = api.trim();
  try {
    final dt = DateFormat('hh:mm a', 'en').parse(t);
    return DateFormat('HH:mm').format(dt);
  } catch (_) {
    try {
      final dt = DateFormat('HH:mm').parse(t);
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return t;
    }
  }
}

/// Converts picker `HH:mm` to API style `"08:00 AM"`.
String hhmmToApiTime(String hhmm) {
  if (hhmm.trim().isEmpty) return '';
  try {
    final dt = DateFormat('HH:mm', 'en').parse(hhmm.trim());
    return DateFormat('hh:mm a', 'en').format(dt);
  } catch (_) {
    if (RegExp(r'(?i)\s*(am|pm)\s*').hasMatch(hhmm)) {
      return hhmm.trim();
    }
    return hhmm.trim();
  }
}

List<OperatingHoursTimeSlot> _timeSlotsFromJson(dynamic value) {
  if (value == null) return [];
  if (value is String) return [];
  if (value is! List) return [];
  return value
      .whereType<Map>()
      .map(
        (e) => OperatingHoursTimeSlot.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
      .toList();
}

OperatingHoursModel operatingHoursModelFromJson(dynamic str) {
  if (str is! Map<String, dynamic>) {
    return OperatingHoursModel();
  }
  return OperatingHoursModel.fromJson(str);
}

String operatingHoursModelToJson(OperatingHoursModel data) =>
    json.encode(data.toJson());

class OperatingHoursModel {
  OperatingHoursData? data;

  OperatingHoursModel({this.data});

  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) {
    return OperatingHoursModel(
      data: json['data'] is Map
          ? OperatingHoursData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'data': data?.toJson()};
}

class OperatingHoursData {
  bool? isTemporarilyClosed;
  List<OperatingHoursDaily>? dailyHours;

  OperatingHoursData({this.isTemporarilyClosed, this.dailyHours});

  factory OperatingHoursData.fromJson(Map<String, dynamic> json) {
    return OperatingHoursData(
      isTemporarilyClosed: _asBool(json['isTemporarilyClosed']),
      dailyHours: json['dailyHours'] is List
          ? (json['dailyHours'] as List)
                .whereType<Map>()
                .map(
                  (e) => OperatingHoursDaily.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'isTemporarilyClosed': isTemporarilyClosed ?? false,
    'dailyHours': dailyHours?.map((e) => e.toJson()).toList() ?? [],
  };
}

class OperatingHoursDaily {
  String? dayOfWeek;
  bool? isEnabled;
  List<OperatingHoursTimeSlot>? timeSlots;

  OperatingHoursDaily({this.dayOfWeek, this.isEnabled, this.timeSlots});

  factory OperatingHoursDaily.fromJson(Map<String, dynamic> json) {
    return OperatingHoursDaily(
      dayOfWeek: _asString(json['dayOfWeek']),
      isEnabled: _asBool(json['isEnabled']),
      timeSlots: _timeSlotsFromJson(json['timeSlots']),
    );
  }

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'isEnabled': isEnabled ?? false,
    'timeSlots':
        timeSlots?.map((e) => e.toJson()).toList() ?? <Map<String, dynamic>>[],
  };
}

class OperatingHoursTimeSlot {
  String? startTime;
  String? endTime;

  OperatingHoursTimeSlot({this.startTime, this.endTime});

  factory OperatingHoursTimeSlot.fromJson(Map<String, dynamic> json) {
    return OperatingHoursTimeSlot(
      startTime: _asString(json['startTime']),
      endTime: _asString(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() => {
    'startTime': startTime ?? '',
    'endTime': endTime ?? '',
  };
}
