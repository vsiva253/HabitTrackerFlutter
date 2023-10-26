import 'package:flutter/material.dart';

class Habit {
  final String name;
  final List<bool> completed;
  int duration; // Added duration property
  String question;
  String unit;
  int targetDays;
  String frequency;
  String targetType;
  TimeOfDay reminder;
  String note;

  Habit({
    required this.name,
    required this.duration,
    required this.question,
    required this.unit,
    required this.targetDays,
    required this.frequency,
    required this.targetType,
    required this.reminder,
    required this.note,
  }) : completed = List.filled(duration, false);

  int get totalDays => duration;
}
