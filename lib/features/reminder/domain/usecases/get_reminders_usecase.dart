import 'package:injectable/injectable.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

@injectable
class GetRemindersUseCase {
  final ReminderRepository _repository;

  GetRemindersUseCase(this._repository);

  Future<List<Reminder>> execute() {
    return _repository.getReminders();
  }
}
