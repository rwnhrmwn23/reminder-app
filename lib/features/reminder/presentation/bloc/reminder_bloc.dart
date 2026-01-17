import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/add_reminder_usecase.dart';
import '../../domain/usecases/delete_reminder_usecase.dart';
import '../../domain/usecases/get_reminders_usecase.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

@injectable
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final GetRemindersUseCase _getRemindersUseCase;
  final AddReminderUseCase _addReminderUseCase;
  final DeleteReminderUseCase _deleteReminderUseCase;

  ReminderBloc(
    this._getRemindersUseCase,
    this._addReminderUseCase,
    this._deleteReminderUseCase,
  ) : super(ReminderInitial()) {
    on<LoadRemindersEvent>(_onLoadReminders);
    on<AddReminderEvent>(_onAddReminder);
    on<DeleteReminderEvent>(_onDeleteReminder);
  }

  Future<void> _onLoadReminders(
    LoadRemindersEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      final reminders = await _getRemindersUseCase.execute();
      emit(ReminderLoaded(reminders));
    } catch (e) {
      emit(ReminderError("Failed to load reminders: $e"));
    }
  }

  Future<void> _onAddReminder(
    AddReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      await _addReminderUseCase.execute(event.reminder);
      add(LoadRemindersEvent());
    } catch (e) {
      emit(ReminderError("Failed to add reminder: $e"));
    }
  }

  Future<void> _onDeleteReminder(
    DeleteReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());
    try {
      await _deleteReminderUseCase.execute(event.id);
      add(LoadRemindersEvent());
    } catch (e) {
      emit(ReminderError("Failed to delete reminder: $e"));
    }
  }
}
