import 'package:injectable/injectable.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource.dart';
import '../models/reminder_model.dart';

@Injectable(as: ReminderRepository)
class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource _localDataSource;

  ReminderRepositoryImpl(this._localDataSource);

  @override
  Future<int> addReminder(Reminder reminder) async {
    final model = ReminderModel.fromEntity(reminder);
    return await _localDataSource.addReminder(model);
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _localDataSource.deleteReminder(id);
  }

  @override
  Future<List<Reminder>> getReminders() async {
    final models = await _localDataSource.getReminders();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final model = ReminderModel.fromEntity(reminder);
    await _localDataSource.updateReminder(model);
  }
}
