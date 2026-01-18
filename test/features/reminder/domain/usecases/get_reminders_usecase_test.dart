import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prioritask/features/reminder/domain/entities/reminder.dart';
import 'package:prioritask/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:prioritask/features/reminder/domain/usecases/get_reminders_usecase.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

void main() {
  late GetRemindersUseCase useCase;
  late MockReminderRepository mockRepository;

  setUp(() {
    mockRepository = MockReminderRepository();
    useCase = GetRemindersUseCase(mockRepository);
  });

  final tReminders = [
    Reminder(title: 'Test 1', reminderTime: DateTime.now()),
    Reminder(title: 'Test 2', reminderTime: DateTime.now()),
  ];

  test('should get reminders from the repository', () async {
    // arrange
    when(
      () => mockRepository.getReminders(),
    ).thenAnswer((_) async => tReminders);

    // act
    final result = await useCase.execute();

    // assert
    expect(result, tReminders);
    verify(() => mockRepository.getReminders());
    verifyNoMoreInteractions(mockRepository);
  });
}
