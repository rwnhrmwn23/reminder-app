import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/reminder.dart';
import '../bloc/reminder_bloc.dart';
import 'add_reminder_page.dart';

class ReminderListPage extends StatelessWidget {
  const ReminderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReminderBloc>()..add(LoadRemindersEvent()),
      child: const _ReminderListView(),
    );
  }
}

class _ReminderListView extends StatelessWidget {
  const _ReminderListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Reminders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReminderPage()),
          );

          if (result is Reminder) {
            context.read<ReminderBloc>().add(AddReminderEvent(result));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state is ReminderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReminderError) {
            return Center(child: Text(state.message));
          } else if (state is ReminderLoaded) {
            if (state.reminders.isEmpty) {
              return const Center(child: Text('No reminders yet'));
            }
            return ListView.builder(
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return Dismissible(
                  key: Key(reminder.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    context.read<ReminderBloc>().add(
                      DeleteReminderEvent(reminder.id!),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(reminder.title),
                      subtitle: Text(
                        DateFormat(
                          'MMM d, y - HH:mm',
                        ).format(reminder.reminderTime),
                      ),
                      trailing: Icon(
                        reminder.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_notifications,
                        color: reminder.isCompleted
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
