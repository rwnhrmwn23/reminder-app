part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class LoadRemindersEvent extends ReminderEvent {}

class AddReminderEvent extends ReminderEvent {
  final Reminder reminder;

  const AddReminderEvent(this.reminder);

  @override
  List<Object> get props => [reminder];
}

class DeleteReminderEvent extends ReminderEvent {
  final int id;

  const DeleteReminderEvent(this.id);

  @override
  List<Object> get props => [id];
}
