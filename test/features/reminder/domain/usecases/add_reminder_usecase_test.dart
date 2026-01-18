import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prioritask/core/services/notification_service.dart';
import 'package:prioritask/features/reminder/domain/entities/reminder.dart';
import 'package:prioritask/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:prioritask/features/reminder/domain/usecases/add_reminder_usecase.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late AddReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockRepository = MockReminderRepository();
    mockNotificationService = MockNotificationService();
    useCase = AddReminderUseCase(mockRepository, mockNotificationService);
  });

  final tReminder = Reminder(
    title: 'Test Reminder',
    reminderTime: DateTime.now().add(const Duration(hours: 1)),
  );
  const tId = 1;

  test(
    'should add reminder to repository and schedule notification when not completed',
    () async {
      // arrange
      when(
        () => mockRepository.addReminder(tReminder),
      ).thenAnswer((_) async => tId);
      when(
        () => mockNotificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
        ),
      ).thenAnswer((_) async => {});

      // act
      await useCase.execute(tReminder);

      // assert
      verify(() => mockRepository.addReminder(tReminder));
      verify(
        () => mockNotificationService.scheduleNotification(
          id: tId,
          title: 'Reminder',
          body: tReminder.title,
          scheduledTime: tReminder.reminderTime,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockNotificationService);
    },
  );

  test(
    'should add reminder to repository and cancel notification when IS completed',
    () async {
      // arrange
      final tCompletedReminder = tReminder.copyWith(isCompleted: true);

      when(
        () => mockRepository.addReminder(tCompletedReminder),
      ).thenAnswer((_) async => tId);
      when(
        () => mockNotificationService.cancelNotification(any()),
      ).thenAnswer((_) async => {});

      // act
      await useCase.execute(tCompletedReminder);

      // assert
      verify(() => mockRepository.addReminder(tCompletedReminder));
      verify(() => mockNotificationService.cancelNotification(tId));
      verifyNever(
        () => mockNotificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledTime: any(named: 'scheduledTime'),
        ),
      );
    },
  );
}
