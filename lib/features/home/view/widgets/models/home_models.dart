import 'package:flutter/material.dart';

class QuickActionData {
  final String label;
  final IconData icon;
  final Color color;

  const QuickActionData({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class OverviewStatData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  const OverviewStatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });
}

class OrderCardData {
  final int? orderId;
  final String id;
  final String name;
  final String total;
  final String timeAgo;
  final String items;

  const OrderCardData({
    this.orderId,
    required this.id,
    required this.name,
    required this.total,
    required this.timeAgo,
    required this.items,
  });
}

class PreparingOrderData {
  final String id;
  final int minutesSince;

  const PreparingOrderData({
    required this.id,
    required this.minutesSince,
  });
}

class ActivityPoint {
  final String hour;
  final int value;

  const ActivityPoint({
    required this.hour,
    required this.value,
  });
}
