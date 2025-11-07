# BREEZ Home - Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Clean Architecture](#clean-architecture)
3. [Project Structure](#project-structure)
4. [Design System](#design-system)
5. [State Management](#state-management)
6. [Accessibility](#accessibility)
7. [Testing Strategy](#testing-strategy)
8. [Code Quality Standards](#code-quality-standards)

## Overview

BREEZ Home is a production-grade Flutter application following **Clean Architecture** principles with **BLoC** state management. The codebase emphasizes:

- **Separation of Concerns**: Clear boundaries between UI, business logic, and data
- **Testability**: All layers can be tested independently
- **Maintainability**: Modular components, <300 lines per file
- **Accessibility**: WCAG 2.1 Level AA compliance
- **Performance**: 60fps animations, optimized rendering

## Clean Architecture

### Layer Separation

```
┌─────────────────────────────────────┐
│      Presentation Layer              │
│  (UI, BLoC, Widgets)                │
├─────────────────────────────────────┤
│      Domain Layer                    │
│  (Entities, Use Cases, Interfaces)  │
├─────────────────────────────────────┤
│      Data Layer                      │
│  (Repositories, Models, Data Sources)│
└─────────────────────────────────────┘
```

### Layer Responsibilities

**Presentation Layer** (`lib/presentation/`)
- UI components (screens, widgets)
- BLoC state management
- User input handling
- NO business logic
- NO direct repository access

**Domain Layer** (`lib/domain/`)
- Business entities
- Use cases (application business rules)
- Repository interfaces
- Framework-agnostic (no Flutter imports)

**Data Layer** (`lib/data/`)
- Repository implementations
- Data models (API/DB representations)
- Data sources (API, local storage)
- Data transformation (models ↔ entities)

### Dependency Rule

Dependencies flow **inward**:
- Presentation → Domain ← Data
- Domain layer has NO dependencies on outer layers
- Use dependency injection for loose coupling

## Project Structure

```
lib/
├── core/
│   ├── di/                    # Dependency Injection (get_it)
│   ├── services/              # API, storage, network services
│   ├── theme/                 # AppTheme, colors, typography
│   ├── utils/                 # Helpers, validators, accessibility
│   └── constants/             # App-wide constants
│
├── data/
│   ├── models/                # Data transfer objects
│   ├── repositories/          # Repository implementations
│   └── datasources/           # Remote/local data sources
│
├── domain/
│   ├── entities/              # Business objects
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business logic use cases
│
├── presentation/
│   ├── bloc/                  # BLoC state management
│   │   ├── auth/
│   │   ├── hvac_list/
│   │   └── hvac_control/
│   ├── pages/                 # Full screens
│   │   ├── home/
│   │   ├── login/
│   │   ├── settings/
│   │   └── analytics/
│   └── widgets/               # Reusable components
│       ├── common/            # Shared across app
│       ├── home/              # Home-specific
│       ├── schedule/          # Schedule components
│       ├── login/             # Login components
│       └── unit_detail/       # Unit detail components
│
├── generated/                 # Auto-generated code
│   └── l10n/                  # Internationalization
│
└── main.dart                  # App entry point
```

## Design System

### HVAC UI Kit Package

Custom design system package (`packages/hvac_ui_kit/`) provides:

**Typography** (`HvacTypography`)
```dart
// Predefined text styles
titleLarge, titleMedium, titleSmall
bodyLarge, bodyMedium, bodySmall
labelLarge, labelMedium, labelSmall
buttonLarge, buttonMedium
```

**Colors** (`HvacColors`)
```dart
// Theme colors
primaryOrange, backgroundDark, backgroundCard
textPrimary, textSecondary, textHint
success, warning, error, info
glassBackground, glassShimmer
```

**Spacing** (`HvacSpacing`)
```dart
// Based on 8px grid system
xxs: 4, xs: 8, sm: 12, md: 16
lg: 24, xl: 32, xxl: 48
```

**Components**
- `GlassCard`: Glassmorphism container
- `HvacButton`: Primary, secondary, text buttons
- `HvacTextField`: Form inputs
- `AdaptiveControl`: Responsive builder
- `MicroInteraction`: Tap feedback
- `SmoothAnimations`: Fade, scale, slide

### Responsive Design

**Breakpoints**
- Mobile: <600dp (primary focus)
- Tablet: 600-1024dp
- Desktop: >1024dp

**Responsive Utilities**
```dart
// All dimensions use responsive extensions
width: 320.w        // Responsive width
height: 450.h       // Responsive height
fontSize: 14.sp     // Scaled font size
radius: 8.r         // Responsive radius
```

**Layout Strategy**
- Mobile-first design
- Adaptive layouts using `AdaptiveControl`
- Breakpoint-based UI adjustments
- Touch targets ≥48x48dp

## State Management

### BLoC Pattern

**Structure**
```dart
// State definition
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {}

// Event definition
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {}
class LogoutRequested extends AuthEvent {}

// BLoC implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
}
```

**Best Practices**
- One BLoC per feature
- Emit states, never mutate
- Use sealed classes for exhaustive handling
- Handle loading/error/success states
- Use use cases, not repositories

### State Handling Pattern

Every screen must handle:
1. **Loading State**: Shimmer skeleton UI
2. **Error State**: User-friendly message + retry
3. **Empty State**: Illustration + helpful message
4. **Success State**: Rendered data

```dart
BlocBuilder<HvacListBloc, HvacListState>(
  builder: (context, state) {
    return switch (state) {
      HvacListLoading() => const ShimmerLoader(),
      HvacListError(:final message) => ErrorState(message),
      HvacListEmpty() => const EmptyState(),
      HvacListLoaded(:final units) => UnitList(units),
    };
  },
)
```

## Accessibility

### WCAG 2.1 Level AA Compliance

**Semantic Labels**
```dart
// IconButton with semantics
AccessibilityHelpers.createSemanticIconButton(
  icon: Icons.settings,
  onPressed: onSettingsPressed,
  label: 'Settings',
  hint: 'Open application settings',
)

// Text field
Semantics(
  label: 'Email',
  hint: 'Enter your email address',
  textField: true,
  child: TextField(...),
)
```

**Touch Targets**
- Minimum 48x48dp for all interactive elements
- Adequate spacing between tap targets

**Color Contrast**
- WCAG AA: ≥4.5:1 for normal text
- WCAG AA: ≥3:1 for large text
- All colors tested with contrast analyzer

**Screen Reader Support**
- Semantic labels on all interactive widgets
- Meaningful hints for actions
- Proper focus order
- Live regions for dynamic content

### Accessibility Utilities

`lib/core/utils/accessibility_helpers.dart` provides:
- `semanticIconButton()`: Wrap IconButton with labels
- `semanticSwitch()`: Accessible switches
- `semanticImage()`: Image descriptions
- `semanticInteractive()`: Generic wrapper
- Common hints: `tapToOpen`, `tapToEdit`, etc.

## Testing Strategy

### Test Structure
```
test/
├── unit/              # Business logic tests
│   ├── usecases/
│   └── repositories/
├── widget/            # Widget tests
│   ├── pages/
│   └── widgets/
└── integration/       # E2E tests
```

### Widget Testing Pattern
```dart
testWidgets('renders correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MyWidget(data: testData),
    ),
  );

  expect(find.text('Expected Text'), findsOneWidget);
  expect(find.byIcon(Icons.check), findsOneWidget);
});
```

### BLoC Testing Pattern
```dart
blocTest<AuthBloc, AuthState>(
  'emits [Loading, Success] when login succeeds',
  build: () => AuthBloc(loginUseCase: mockLoginUseCase),
  act: (bloc) => bloc.add(LoginRequested()),
  expect: () => [AuthLoading(), AuthSuccess()],
);
```

### Coverage Goals
- Unit tests: >85% for use cases and repositories
- Widget tests: Core components and screens
- Integration tests: Critical user flows

## Code Quality Standards

### File Organization

**Maximum File Size**: 300 lines
- Enforced strictly
- Extract components when approaching limit
- Use barrel files for organization

**Component Extraction**
```dart
// BAD: 500-line screen with inline widgets
class HomeScreen extends StatelessWidget {
  // 500 lines of nested widgets
}

// GOOD: Clean screen + extracted components
class HomeScreen extends StatelessWidget { // 80 lines
  Widget build(context) => Column([
    HomeHeader(),    // extracted
    DeviceList(),    // extracted
    QuickActions(),  // extracted
  ]);
}
```

### Naming Conventions

**Files**: `snake_case.dart`
- `home_screen.dart`
- `hvac_card.dart`
- `accessibility_helpers.dart`

**Classes**: `PascalCase`
- `HomeScreen`
- `HvacCard`
- `AccessibilityHelpers`

**Variables/Functions**: `camelCase`
- `selectedUnit`
- `onUnitSelected`
- `buildHeader()`

**Private members**: prefix with `_`
- `_buildCard()`
- `_controller`

### SOLID Principles

**Single Responsibility**
- Each class has ONE reason to change
- Extract when responsibilities grow

**Open/Closed**
- Extend behavior via composition
- Use strategy pattern for variants

**Liskov Substitution**
- Subtypes must be substitutable
- Honor base class contracts

**Interface Segregation**
- Many specific interfaces > one general
- Don't force unneeded dependencies

**Dependency Inversion**
- Depend on abstractions (interfaces)
- Use dependency injection

### Code Review Checklist

✅ File is <300 lines
✅ Follows Clean Architecture
✅ All dimensions use responsive extensions
✅ No hard-coded strings (use l10n)
✅ Loading/error/empty states handled
✅ Semantic labels on interactive widgets
✅ `dart analyze` produces 0 errors/warnings
✅ Tests written/updated
✅ const constructors used

### Performance Optimization

**Rendering**
- Use `const` constructors wherever possible
- `RepaintBoundary` for complex widgets
- `ListView.builder` for long lists (not `ListView`)
- Avoid deep nesting (max 5 levels)

**State Management**
- Don't rebuild entire screen for small changes
- Use `BlocBuilder` with precise selectors
- Leverage `BlocListener` for side effects

**Assets**
- Optimize images (WebP format)
- Lazy load heavy resources
- Cache network images
- Lottie animations <200KB

## Development Workflow

### Adding a New Feature

1. **Domain Layer**
   ```dart
   // 1. Create entity
   class NewFeature { ... }

   // 2. Create repository interface
   abstract class NewFeatureRepository { ... }

   // 3. Create use case
   class GetNewFeatureUseCase { ... }
   ```

2. **Data Layer**
   ```dart
   // 4. Create model
   class NewFeatureModel { ... }

   // 5. Implement repository
   class NewFeatureRepositoryImpl implements NewFeatureRepository { ... }
   ```

3. **Presentation Layer**
   ```dart
   // 6. Create BLoC
   class NewFeatureBloc extends Bloc<NewFeatureEvent, NewFeatureState> { ... }

   // 7. Create UI components
   class NewFeatureScreen extends StatelessWidget { ... }
   ```

4. **Dependency Injection**
   ```dart
   // 8. Register in DI
   void setupDependencies() {
     getIt.registerLazySingleton<NewFeatureRepository>(
       () => NewFeatureRepositoryImpl(),
     );
   }
   ```

5. **Testing**
   ```dart
   // 9. Write tests
   test/unit/usecases/new_feature_usecase_test.dart
   test/widget/pages/new_feature_screen_test.dart
   ```

### Before Committing

```bash
# Format code
dart format lib/ packages/ test/

# Analyze
dart analyze

# Run tests
flutter test

# Check coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Migration Guide

### From Old UI to HVAC UI Kit

```dart
// OLD: Hard-coded styles
Container(
  color: Color(0xFFFF6B00),
  child: Text(
    'Title',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
)

// NEW: Design system
HvacCard(
  child: Text(
    'Title',
    style: HvacTypography.titleLarge,
  ),
)
```

### From Hard-coded Dimensions to Responsive

```dart
// OLD
width: 320
height: 450
fontSize: 14

// NEW
width: 320.w
height: 450.h
fontSize: 14.sp
```

### From Direct Repository to BLoC

```dart
// OLD: Direct repository call in widget
class MyWidget extends StatelessWidget {
  Widget build(context) {
    final data = repository.getData(); // ❌ Wrong!
    return Text(data);
  }
}

// NEW: Through BLoC
class MyWidget extends StatelessWidget {
  Widget build(context) {
    return BlocBuilder<MyBloc, MyState>(
      builder: (context, state) {
        return switch (state) {
          MyLoading() => LoadingIndicator(),
          MyLoaded(:final data) => Text(data),
        };
      },
    );
  }
}
```

## Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

### Tools
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
- [Dart Analyzer](https://dart.dev/tools/dart-analyze)
- [Very Good CLI](https://pub.dev/packages/very_good_cli)

---

**Last Updated**: November 2025
**Code Health Score**: 8.5/10
**Analyzer Status**: 0 errors, 0 warnings, 11 info
**Architecture Compliance**: Clean Architecture + BLoC
