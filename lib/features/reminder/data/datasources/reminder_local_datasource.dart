import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/reminder_model.dart';

@singleton
class ReminderLocalDataSource {
  late Future<Isar> _db;

  ReminderLocalDataSource() {
    _db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ReminderModelSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Isar.getInstance()!;
  }

  Future<int> addReminder(ReminderModel reminder) async {
    final isar = await _db;
    return await isar.writeTxn(() async {
      return await isar.reminderModels.put(reminder);
    });
  }

  Future<void> deleteReminder(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.reminderModels.delete(id);
    });
  }

  Future<List<ReminderModel>> getReminders() async {
    final isar = await _db;
    return await isar.reminderModels.where().sortByReminderTime().findAll();
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.reminderModels.put(reminder);
    });
  }
}
