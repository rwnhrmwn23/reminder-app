import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/styles/app_style.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/reminder.dart';
import '../bloc/reminder_bloc.dart';
import '../widgets/progress_card.dart';
import '../widgets/week_strip.dart';
import '../widgets/add_reminder_modal.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  DateTime _selectedDate = DateTime.now();
  final Set<Priority> _collapsedPriorities = {};
  bool _isDoneSectionCollapsed = false;

  @override
  void initState() {
    super.initState();
    context.read<ReminderBloc>().add(LoadRemindersEvent());
  }

  List<Reminder> _getRemindersForPriority(
    List<Reminder> allReminders,
    Priority priority, {
    required bool isCompleted,
  }) {
    return allReminders.where((r) {
      final isSameDate = DateUtils.isSameDay(r.reminderTime, _selectedDate);
      return isSameDate &&
          r.priority == priority &&
          r.isCompleted == isCompleted;
    }).toList();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_outlined;
    if (hour < 17) return Icons.wb_cloudy_outlined;
    return Icons.nights_stay_outlined;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.secondaryColor,
      body: SafeArea(
        child: BlocBuilder<ReminderBloc, ReminderState>(
          builder: (context, state) {
            List<Reminder> allReminders = [];
            if (state is ReminderLoaded) {
              allReminders = state.reminders;
            } else if (state is ReminderError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hi, Kak!', style: AppStyle.headlineMedium),
                            Row(
                              children: [
                                Icon(
                                  _getGreetingIcon(),
                                  size: 16,
                                  color: AppStyle.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getGreeting(),
                                  style: AppStyle.bodyMedium.copyWith(
                                    color: AppStyle.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppStyle.backgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) => BlocProvider.value(
                                value: context.read<ReminderBloc>(),
                                child: AddReminderModal(
                                  initialPriority: Priority.none,
                                  initialDate: _selectedDate,
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.add,
                            size: 32,
                            color: AppStyle.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  WeekStrip(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),

                  ProgressCard(
                    totalTasks: allReminders
                        .where(
                          (r) => DateUtils.isSameDay(
                            r.reminderTime,
                            _selectedDate,
                          ),
                        )
                        .length,
                    completedTasks: allReminders
                        .where(
                          (r) =>
                              DateUtils.isSameDay(
                                r.reminderTime,
                                _selectedDate,
                              ) &&
                              r.isCompleted,
                        )
                        .length,
                    isForToday: DateUtils.isSameDay(
                      _selectedDate,
                      DateTime.now(),
                    ),
                  ),

                  _buildPrioritySection(
                    'HIGH',
                    Priority.high,
                    allReminders,
                    AppStyle.priorityHighBg,
                    Icons.arrow_upward_rounded,
                    AppStyle.priorityHighText,
                  ),
                  _buildPrioritySection(
                    'MEDIUM',
                    Priority.medium,
                    allReminders,
                    AppStyle.priorityMediumBg,
                    Icons.error_outline_rounded,
                    AppStyle.priorityMediumText,
                  ),
                  _buildPrioritySection(
                    'LOW',
                    Priority.low,
                    allReminders,
                    AppStyle.priorityLowBg,
                    Icons.arrow_downward_rounded,
                    AppStyle.priorityLowText,
                  ),
                  _buildPrioritySection(
                    'TO-DO',
                    Priority.none,
                    allReminders,
                    AppStyle.priorityTodoBg,
                    Icons.circle_outlined,
                    AppStyle.priorityTodoText,
                  ),

                  _buildDoneSection(allReminders),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrioritySection(
    String label,
    Priority priority,
    List<Reminder> allReminders,
    Color chipColor,
    IconData icon,
    Color iconColor,
  ) {
    // Get active only
    final reminders = _getRemindersForPriority(
      allReminders,
      priority,
      isCompleted: false,
    );

    final isCollapsed = _collapsedPriorities.contains(priority);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isCollapsed) {
                        _collapsedPriorities.remove(priority);
                      } else {
                        _collapsedPriorities.add(priority);
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 15, color: iconColor),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: AppStyle.priorityLabel.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isCollapsed ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_up, size: 15),
                      ),
                    ],
                  ),
                ),
              ),

              if (reminders.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppStyle.backgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => BlocProvider.value(
                        value: context.read<ReminderBloc>(),
                        child: AddReminderModal(
                          initialPriority: priority,
                          initialDate: _selectedDate,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppStyle.grey300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 15,
                      color: AppStyle.grey,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isCollapsed
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (reminders.isEmpty)
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: AppStyle.backgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) => BlocProvider.value(
                                value: context.read<ReminderBloc>(),
                                child: AddReminderModal(
                                  initialPriority: priority,
                                  initialDate: _selectedDate,
                                ),
                              ),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppStyle.grey300,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getEmptyPlaceholder(label),
                                    style: AppStyle.bodyMedium.copyWith(
                                      color: AppStyle.grey,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: AppStyle.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ...reminders.map(
                          (reminder) => _buildReminderTile(reminder),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _getEmptyPlaceholder(String label) {
    switch (label) {
      case 'HIGH':
        return 'Need focus - add here';
      case 'MEDIUM':
        return 'Not urgent - add here';
      case 'LOW':
        return 'No rush - add here';
      default:
        return 'Add it to your list';
    }
  }

  Widget _buildDoneSection(List<Reminder> allReminders) {
    final doneReminders = allReminders.where((r) {
      final isSameDate = DateUtils.isSameDay(r.reminderTime, _selectedDate);
      return isSameDate && r.isCompleted;
    }).toList();

    if (doneReminders.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppStyle.successGreenBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isDoneSectionCollapsed = !_isDoneSectionCollapsed;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: AppStyle.successGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'DONE (${doneReminders.length})',
                    style: AppStyle.priorityLabel.copyWith(letterSpacing: 1.5),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isDoneSectionCollapsed ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_up, size: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isDoneSectionCollapsed
                ? const SizedBox(width: double.infinity)
                : Column(
                    children: doneReminders
                        .map((r) => _buildReminderTile(r, isDone: true))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTile(Reminder reminder, {bool isDone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppStyle.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<ReminderBloc>().add(
                AddReminderEvent(reminder.copyWith(isCompleted: !isDone)),
              );
            },
            child: isDone
                ? const Icon(
                    Icons.check_circle,
                    color: AppStyle.successGreen,
                    size: 24,
                  )
                : Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppStyle.grey, width: 2),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppStyle.backgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) => BlocProvider.value(
                    value: context.read<ReminderBloc>(),
                    child: AddReminderModal(
                      initialPriority: reminder.priority,
                      initialDate: reminder.reminderTime,
                      reminder: reminder,
                    ),
                  ),
                );
              },
              child: Text(
                reminder.title,
                style: AppStyle.bodyMedium.copyWith(
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? AppStyle.grey : AppStyle.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
