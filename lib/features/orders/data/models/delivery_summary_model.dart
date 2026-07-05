String? _dsString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

bool? _dsBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is String) {
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;
  }
  return null;
}

DeliverySummaryModel? deliverySummaryFromJson(dynamic json) {
  if (json == null) return null;
  if (json is! Map) return null;
  return DeliverySummaryModel.fromJson(Map<String, dynamic>.from(json));
}

class DeliverySummaryModel {
  bool enabled;
  String? status;
  String? statusLabelAr;
  String? currentStage;
  bool isTerminal;
  String? pickupMode;
  String? readyForPickupAt;
  String? pickedUpAt;
  String? completedAt;
  String? cancelledAt;
  String? cancellationReason;
  List<DeliverySummaryTimelineItemModel> timeline;

  DeliverySummaryModel({
    this.enabled = false,
    this.status,
    this.statusLabelAr,
    this.currentStage,
    this.isTerminal = false,
    this.pickupMode,
    this.readyForPickupAt,
    this.pickedUpAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.timeline = const [],
  });

  factory DeliverySummaryModel.fromJson(Map<String, dynamic> json) {
    return DeliverySummaryModel(
      enabled: _dsBool(json['enabled']) ?? false,
      status: _dsString(json['status']),
      statusLabelAr: _dsString(json['statusLabelAr']),
      currentStage: _dsString(json['currentStage']),
      isTerminal: _dsBool(json['isTerminal']) ?? false,
      pickupMode: _dsString(json['pickupMode']),
      readyForPickupAt: _dsString(json['readyForPickupAt']),
      pickedUpAt: _dsString(json['pickedUpAt']),
      completedAt: _dsString(json['completedAt']),
      cancelledAt: _dsString(json['cancelledAt']),
      cancellationReason: _dsString(json['cancellationReason']),
      timeline: json['timeline'] is List
          ? (json['timeline'] as List)
              .whereType<Map>()
              .map((e) => DeliverySummaryTimelineItemModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
    );
  }
}

class DeliverySummaryTimelineItemModel {
  String? key;
  String? timestamp;
  bool completed;
  bool active;

  DeliverySummaryTimelineItemModel({
    this.key,
    this.timestamp,
    this.completed = false,
    this.active = false,
  });

  factory DeliverySummaryTimelineItemModel.fromJson(Map<String, dynamic> json) {
    return DeliverySummaryTimelineItemModel(
      key: _dsString(json['key']),
      timestamp: _dsString(json['timestamp']),
      completed: _dsBool(json['completed']) ?? false,
      active: _dsBool(json['active']) ?? false,
    );
  }

  static const stageLabels = <String, String>{
    'driver_en_route': 'المندوب في الطريق',
    'arrived': 'وصل المندوب',
    'handover_complete': 'تم التسليم للمندوب',
    'completed': 'مكتمل',
    'not_received': 'لم يُستلم',
    'cancelled': 'ملغى',
  };

  String get label => stageLabels[key ?? ''] ?? key ?? '—';
}
