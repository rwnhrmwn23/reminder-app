import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<int> addReminder(Reminder reminder);
  Future<void> deleteReminder(int id);
  Future<List<Reminder>> getReminders();
  Future<void> updateReminder(Reminder reminder);
}
