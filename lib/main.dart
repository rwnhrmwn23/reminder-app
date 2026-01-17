import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/services/notification_service.dart';
import 'core/styles/app_style.dart';
import 'features/reminder/presentation/pages/reminder_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI
  await configureDependencies();

  // Initialize Notifications
  final notificationService = getIt<NotificationService>();
  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: AppStyle.lightTheme,
      home: const ReminderListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
