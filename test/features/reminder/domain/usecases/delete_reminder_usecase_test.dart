import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prioritask/core/services/notification_service.dart';
import 'package:prioritask/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:prioritask/features/reminder/domain/usecases/delete_reminder_usecase.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late DeleteReminderUseCase useCase;
  late MockReminderRepository mockRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockRepository = MockReminderRepository();
    mockNotificationService = MockNotificationService();
    useCase = DeleteReminderUseCase(mockRepository, mockNotificationService);
  });

  const tId = 1;

  test(
    'should delete reminder from repository and cancel notification',
    () async {
      // arrange
      when(
        () => mockRepository.deleteReminder(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockNotificationService.cancelNotification(any()),
      ).thenAnswer((_) async => {});

      // act
      await useCase.execute(tId);

      // assert
      verify(() => mockRepository.deleteReminder(tId));
      verify(() => mockNotificationService.cancelNotification(tId));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockNotificationService);
    },
  );
}
