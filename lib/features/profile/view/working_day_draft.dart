import '../data/models/operating_hours_model.dart';

/// Local editable state for one weekday on [WorkingTimeScreen].
/// UI index 0 = Sunday … 6 = Saturday (matches [DateTime.weekday] with Sunday as 0).
class WorkingDayDraft {
  WorkingDayDraft({required this.isEnabled, List<OperatingHoursTimeSlot>? slots})
    : slots = slots ?? [];

  bool isEnabled;
  final List<OperatingHoursTimeSlot> slots;
}
