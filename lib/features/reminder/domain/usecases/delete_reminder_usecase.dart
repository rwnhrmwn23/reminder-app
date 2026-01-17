import 'package:injectable/injectable.dart';
import '../../../../core/services/notification_service.dart';
import '../repositories/reminder_repository.dart';

@injectable
class DeleteReminderUseCase {
  final ReminderRepository _repository;
  final NotificationService _notificationService;

  DeleteReminderUseCase(this._repository, this._notificationService);

  Future<void> execute(int id) async {
    await _repository.deleteReminder(id);

    await _notificationService.cancelNotification(id);
  }
}
