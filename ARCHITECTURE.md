# Clean Architecture Implementation

## Overview

This HVAC Control application follows **Clean Architecture** principles with strict layer separation and dependency rules. The architecture ensures maintainability, testability, and scalability.

## Architecture Layers

### 1. **Presentation Layer** (`lib/presentation/`)
- **Responsibility**: UI components and state management
- **Components**:
  - Screens/Pages: UI layouts
  - Widgets: Reusable UI components
  - BLoCs: State management (uses domain use cases)
- **Dependencies**: Only depends on Domain layer
- **Key Rule**: NO business logic, NO direct repository access

### 2. **Domain Layer** (`lib/domain/`)
- **Responsibility**: Business logic and rules
- **Components**:
  - Entities: Core business objects
  - Use Cases: Business operations
  - Repository Interfaces: Contracts for data operations
- **Dependencies**: NONE (pure Dart, no framework dependencies)
- **Key Rule**: The most stable layer, changes rarely

### 3. **Data Layer** (`lib/data/`)
- **Responsibility**: Data access and external services
- **Components**:
  - Repository Implementations: Concrete implementations
  - Data Sources: API clients, database, cache
  - Models: Data transfer objects with JSON serialization
- **Dependencies**: Depends on Domain layer (implements interfaces)
- **Key Rule**: Handles all external communication

### 4. **Core/Infrastructure** (`lib/core/`)
- **Responsibility**: Shared utilities and services
- **Components**:
  - Dependency Injection
  - Configuration
  - Theme/Styling
  - Common utilities
- **Dependencies**: Can be used by any layer
- **Key Rule**: Framework-specific code lives here

## Dependency Flow

```
Presentation → Domain ← Data
     ↓           ↑        ↓
     └─────── Core ───────┘
```

## Key Principles

### 1. Dependency Rule
- Dependencies point **inward** only
- Inner layers know nothing about outer layers
- Domain layer is the center with no external dependencies

### 2. Abstraction
- Domain defines interfaces (abstract classes)
- Data layer implements these interfaces
- Presentation uses abstractions through dependency injection

### 3. Single Responsibility
- Each class has one reason to change
- Use cases encapsulate single business operations
- BLoCs handle single feature's state

### 4. Dependency Injection
- All dependencies injected via constructor
- No direct instantiation of concrete classes
- Managed by `get_it` service locator

## File Structure

```
lib/
├── presentation/           # UI Layer
│   ├── bloc/              # State management
│   │   ├── auth/          # Authentication BLoC
│   │   ├── hvac_list/     # Device list BLoC
│   │   └── hvac_detail/   # Device detail BLoC
│   ├── screens/           # App screens
│   └── widgets/           # Reusable widgets
│
├── domain/                # Business Logic Layer
│   ├── entities/          # Business objects
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business operations
│       ├── auth/          # Authentication use cases
│       ├── device/        # Device management
│       └── ...            # Other operations
│
├── data/                  # Data Access Layer
│   ├── repositories/      # Repository implementations
│   ├── datasources/       # Remote/local data sources
│   └── models/            # Data models with serialization
│
└── core/                  # Shared/Infrastructure
    ├── di/                # Dependency injection
    ├── services/          # Core services
    ├── theme/             # App theming
    └── utils/             # Utilities
```

## Use Case Pattern

Each use case follows this pattern:

```dart
class DoSomething {
  final Repository _repository;

  DoSomething(this._repository);

  Future<Result> call(Params params) async {
    // 1. Validate input
    // 2. Apply business rules
    // 3. Delegate to repository
    // 4. Transform result
    // 5. Handle errors
  }
}
```

## BLoC Pattern with Use Cases

BLoCs should ONLY use use cases:

```dart
class FeatureBloc extends Bloc<Event, State> {
  final UseCase1 _useCase1;
  final UseCase2 _useCase2;

  FeatureBloc({
    required UseCase1 useCase1,
    required UseCase2 useCase2,
  }) : _useCase1 = useCase1,
       _useCase2 = useCase2,
       super(InitialState());
}
```

## Entity/Model Separation

- **Entities** (Domain): Pure business objects
- **Models** (Data): Include serialization logic

```dart
// Domain Entity
class User {
  final String id;
  final String name;
  // ... pure properties
}

// Data Model
class UserModel extends User {
  // ... includes fromJson, toJson, fromEntity, toEntity
}
```

## Testing Strategy

### Unit Tests
- **Domain**: Test use cases with mocked repositories
- **Data**: Test repositories with mocked data sources
- **Presentation**: Test BLoCs with mocked use cases

### Integration Tests
- Test complete feature flows
- Use real implementations where possible

### Widget Tests
- Test UI components in isolation
- Mock BLoCs for controlled state

## Migration Guide

### From Direct Repository Access to Use Cases

**Before (Anti-pattern):**
```dart
class AuthBloc {
  final ApiService _apiService;

  void login(email, password) async {
    final response = await _apiService.login(email, password);
    // Business logic mixed with API calls
  }
}
```

**After (Clean Architecture):**
```dart
class AuthBloc {
  final Login _login;

  void onLogin(event, emit) async {
    final user = await _login(LoginParams(
      email: event.email,
      password: event.password,
    ));
    emit(Authenticated(user));
  }
}
```

## Benefits

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Clear separation of concerns
3. **Scalability**: Easy to add new features
4. **Flexibility**: Can change frameworks/libraries without affecting business logic
5. **Team Collaboration**: Clear boundaries between different parts

## Common Pitfalls to Avoid

❌ **Don't**:
- Put business logic in widgets or BLoCs
- Make direct API calls from presentation layer
- Create circular dependencies between layers
- Mix framework code with business logic
- Skip use cases for "simple" operations

✅ **Do**:
- Keep domain layer pure (no Flutter imports)
- Use dependency injection consistently
- Create use cases for ALL business operations
- Maintain clear entity/model separation
- Test each layer independently

## Architecture Decision Records (ADRs)

### ADR-001: Use Case for Every Operation
**Decision**: Create a use case for every business operation, even simple ones
**Reason**: Consistency, testability, and future-proofing

### ADR-002: BLoC Pattern for State Management
**Decision**: Use BLoC pattern with events and states
**Reason**: Predictable state management, testability, separation of concerns

### ADR-003: Repository Pattern
**Decision**: Use repository pattern with interfaces in domain
**Reason**: Abstraction of data sources, testability, flexibility

### ADR-004: Entity/Model Separation
**Decision**: Separate domain entities from data models
**Reason**: Domain purity, serialization isolation, clear boundaries