import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prioritask/features/reminder/domain/entities/reminder.dart';
import 'package:prioritask/features/reminder/domain/usecases/add_reminder_usecase.dart';
import 'package:prioritask/features/reminder/domain/usecases/delete_reminder_usecase.dart';
import 'package:prioritask/features/reminder/domain/usecases/get_reminders_usecase.dart';
import 'package:prioritask/features/reminder/presentation/bloc/reminder_bloc.dart';

class MockGetRemindersUseCase extends Mock implements GetRemindersUseCase {}

class MockAddReminderUseCase extends Mock implements AddReminderUseCase {}

class MockDeleteReminderUseCase extends Mock implements DeleteReminderUseCase {}

void main() {
  late ReminderBloc bloc;
  late MockGetRemindersUseCase mockGetRemindersUseCase;
  late MockAddReminderUseCase mockAddReminderUseCase;
  late MockDeleteReminderUseCase mockDeleteReminderUseCase;

  setUpAll(() {
    registerFallbackValue(
      Reminder(title: 'dummy', reminderTime: DateTime.now()),
    );
  });

  setUp(() {
    mockGetRemindersUseCase = MockGetRemindersUseCase();
    mockAddReminderUseCase = MockAddReminderUseCase();
    mockDeleteReminderUseCase = MockDeleteReminderUseCase();
    bloc = ReminderBloc(
      mockGetRemindersUseCase,
      mockAddReminderUseCase,
      mockDeleteReminderUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tReminder = Reminder(
    id: 1,
    title: 'Test Reminder',
    reminderTime: DateTime.now(),
  );
  final tReminders = [tReminder];

  test('initial state should be ReminderInitial', () {
    expect(bloc.state, equals(ReminderInitial()));
  });

  group('LoadRemindersEvent', () {
    test(
      'should emit [ReminderLoading, ReminderLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(
          () => mockGetRemindersUseCase.execute(),
        ).thenAnswer((_) async => tReminders);

        // act
        bloc.add(LoadRemindersEvent());

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([ReminderLoading(), ReminderLoaded(tReminders)]),
        );
      },
    );

    test(
      'should emit [ReminderLoading, ReminderError] when loading fails',
      () async {
        // arrange
        when(
          () => mockGetRemindersUseCase.execute(),
        ).thenThrow(Exception('Error'));

        // act
        bloc.add(LoadRemindersEvent());

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            ReminderLoading(),
            const ReminderError('Failed to load reminders: Exception: Error'),
          ]),
        );
      },
    );
  });

  group('AddReminderEvent', () {
    test('should call AddReminderUseCase and then add LoadRemindersEvent', () async {
      // arrange
      when(
        () => mockAddReminderUseCase.execute(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockGetRemindersUseCase.execute(),
      ).thenAnswer((_) async => tReminders);

      // act
      bloc.add(AddReminderEvent(tReminder));

      // assert
      await expectLater(
        bloc.stream,
        emitsInOrder([
          ReminderLoading(),
          ReminderLoaded(tReminders),
        ]),
      );

      verify(() => mockAddReminderUseCase.execute(tReminder)).called(1);
    });
  });

  group('DeleteReminderEvent', () {
    test(
      'should call DeleteReminderUseCase and then add LoadRemindersEvent',
      () async {
        // arrange
        const tId = 1;
        when(
          () => mockDeleteReminderUseCase.execute(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockGetRemindersUseCase.execute(),
        ).thenAnswer((_) async => []);

        // act
        bloc.add(const DeleteReminderEvent(tId));

        // assert
        await expectLater(
          bloc.stream,
          emitsInOrder([ReminderLoading(), const ReminderLoaded([])]),
        );

        verify(() => mockDeleteReminderUseCase.execute(tId)).called(1);
      },
    );
  });
}
