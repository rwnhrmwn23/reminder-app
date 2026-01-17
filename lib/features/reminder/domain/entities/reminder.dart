import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final int? id;
  final String title;
  final DateTime reminderTime;
  final bool isCompleted;

  const Reminder({
    this.id,
    required this.title,
    required this.reminderTime,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, title, reminderTime, isCompleted];
}
