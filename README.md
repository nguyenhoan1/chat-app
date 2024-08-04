# Flutter Clean Architecture BLoC Template

This project is a Flutter application implementing Clean Architecture principles with the BLoC (Business Logic Component) pattern for state management.

## Project Structure

The project follows a clean architecture approach with the following main directories:

```
lib/
├── core/
├── data/
│   ├── data_sources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── views/
│   └── widgets/
└── main.dart
```

- `core/`: Contains core functionality and utilities used across the application.
- `data/`: Implements the data layer, including API calls, local storage, and data models.
- `domain/`: Defines the business logic, including entities, repository interfaces, and use cases.
- `presentation/`: Contains the UI layer, including BLoCs, pages, and widgets.

## Getting Started

### Prerequisites

- Flutter SDK (version 3.19.5 or higher)
- Dart SDK (version 3.3.3 or higher)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/your-project-name.git
   ```

2. Navigate to the project directory:
   ```
   cd your-project-name
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Architecture Overview

This project follows Clean Architecture principles, which separates the codebase into layers:

1. **Presentation Layer**: Uses BLoC for state management and contains all UI-related code.
2. **Domain Layer**: Contains business logic, entities, and use case definitions.
3. **Data Layer**: Implements repositories and manages data sources.

## State Management

We use the BLoC (Business Logic Component) pattern for state management. BLoCs are located in the `lib/presentation/bloc/` directory.

Regards, Bagus Subagja. (Update 04/08/2024)
