# Prioritask 📝

A focused, offline-first reminder application built with Flutter, designed to help you organize your day with priorities.

## ✨ Key Features

- **Offline-First**: All data stays on your device. Privacy by design.
- **Smart Dashboard**:
    - **Dynamic Greetings**: Welcomes you with "Good Morning/Afternoon/Evening" based on system time and validates task times.
    - **Progress Tracking**: Visual progress card showing completion percentage of daily tasks.
    - **Week-Strip Calendar**: Seamlessly switch between days to manage your schedule.
- **Priority Management**: Categorize tasks by urgency (High, Medium, Low, None) for better focus.
- **Reliable Notifications**: Scuhdule reminders that work reliably even when the app is closed or terminated.
- **Beautiful UI**: Modern aesthetics inspired by [Community Design](https://www.figma.com/design/IYnjtEFFWxlfOYRUGuvuKk/Reminder-app--Community-?node-id=1-130&p=f&t=8tnyPf6JPR6PWqZr-0) and the Timo app.

<img width="240" height="680" alt="Reference Timo" src="https://github.com/user-attachments/assets/00f87fc8-6d96-4cd6-b661-729052010fb9" />

<img width="523" height="390" alt="Screenshot 2026-01-18 at 14 10 15" src="https://github.com/user-attachments/assets/23e50e9f-44f5-436e-8f38-9ac2e066231a" />

## 🛠 Tech Stack & Architecture

This project follows **Clean Architecture** principles to ensure scalability and testability.

### Architecture Overview
- **Presentation Layer**: Flutter Widgets + BLoC (State Management).
- **Domain Layer**: Pure Dart entities and UseCases (Business Logic).
- **Data Layer**: Repositories and Data Sources (Isar DB implementations).

### Key Technical Decisions

#### Why Isar Database? 🗄️
We chose **Isar** over Hive or Sqflite because:
- **Isar Inspector**: A powerful real-time database inspector that allows viewing and querying data while the app is running (a feature lacking in many alternatives).
- **Performance**: Extremely fast asynchronous operations.
- **Type Safety**: No more raw SQL queries or dynamic mapping maps.
- **Query Power**: Rich query capabilities with composite indexes.
- **Flutter Native**: Built specifically for Flutter/Dart.

<img width="973" height="716" alt="Screenshot 2026-01-18 at 14 23 14" src="https://github.com/user-attachments/assets/8fe9a2b3-0054-41de-b540-227ebf87d425" />

#### State Management (BLoC) ⚡
We use **flutter_bloc** to separate business logic from UI. This ensures:
- Predictable state changes (Loading -> Loaded -> Error).
- Easy testing of logic (bypassing UI).
- Clear separation of concerns.

#### Dependency Injection (GetIt + Injectable) 💉
- **injectable**: Generates dependency injection code, reducing boilerplate.
- **get_it**: Service locator for accessing dependencies anywhere.

## 🚀 Setup & Running

1. **Clone the repository**
2. **Install Dependencies**
   ```bash
   flutter pub get
   ```
3. **Generate Code** (Required for Database & DI)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run the App**
   ```bash
   flutter run
   ```
5. **Run Tests**
   ```bash
   flutter test
   ```

## 📸 Screen Previews

### Onboarding
<img width="240" height="780" alt="Seamless Offline Mode" src="https://github.com/user-attachments/assets/ad1b4cac-04f2-4556-959b-2e11c9236c2b" />

<img width="240" height="780" alt="Smart Prioritization" src="https://github.com/user-attachments/assets/7118ce53-3041-4b3c-9c0f-f08d34b407ad" />

<img width="240" height="780" alt="Track Your Success" src="https://github.com/user-attachments/assets/fec195e9-9283-43d1-953a-3b18f09b8c0a" />

### Home / ToDo
<img width="240" height="780" alt="List Todo" src="https://github.com/user-attachments/assets/92d69270-4c69-4fb7-b4c0-d4f430fede13" />

<img width="240" height="780" alt="List Todo" src="https://github.com/user-attachments/assets/f4f1a9fd-683c-4998-b306-c8dc1aa3d215" />

### Add Task
<img width="240" height="780" alt="Add Task Modal" src="https://github.com/user-attachments/assets/15e618b4-edef-498e-b073-a37eb06771dc" />

### Notification Reminder
<img width="240" height="780" alt="Push Notification" src="https://github.com/user-attachments/assets/f4678b81-89fb-4264-a3a3-8aa68ec54b7e" />

## 🧪 Testing

Unit tests cover the core business logic (Domain Layer) and State Management (BLoC).
- **Mocktail** is used for mocking dependencies.
- Tests mirror the `lib` structure in `test/`.

```bash
flutter test
```
