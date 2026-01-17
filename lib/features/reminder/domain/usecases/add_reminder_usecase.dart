import 'package:injectable/injectable.dart';
import '../../../../core/services/notification_service.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

@injectable
class AddReminderUseCase {
  final ReminderRepository _repository;
  final NotificationService _notificationService;

  AddReminderUseCase(this._repository, this._notificationService);

  Future<void> execute(Reminder reminder) async {
    final int id = await _repository.addReminder(reminder);

    await _notificationService.scheduleNotification(
      id: id,
      title: 'Reminder',
      body: reminder.title,
      scheduledTime: reminder.reminderTime,
    );
  }
}
