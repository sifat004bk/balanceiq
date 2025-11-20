# Development Guide

This guide provides practical instructions for extending and modifying BalanceIQ.

## Table of Contents
1. [Setup](#setup)
2. [Adding a New Feature](#adding-a-new-feature)
3. [Modifying Existing Features](#modifying-existing-features)
4. [Database Changes](#database-changes)
5. [Adding New API Endpoints](#adding-new-api-endpoints)
6. [UI Customization](#ui-customization)
7. [Common Tasks](#common-tasks)
8. [Best Practices](#best-practices)
9. [Debugging](#debugging)

## Setup

### Prerequisites
```bash
# Check Flutter installation
flutter doctor

# Should show:
# Flutter SDK: 3.27.0+
# Dart SDK: 3.6.0+
```

### Initial Setup
```bash
# Clone and install dependencies
git clone <repository-url>
cd balanceIQ
flutter pub get

# Setup environment
cp .env.example .env

# Edit .env with your API URLs
nano .env
```

### Running the App
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run

# Run in release mode
flutter run --release
```

## Adding a New Feature

Follow Clean Architecture principles: Domain → Data → Presentation

### Example: Add "Categories" Feature

#### Step 1: Domain Layer (Business Logic)

**Create Entity** (`lib/features/categories/domain/entities/category.dart`):
```dart
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, icon, color];
}
```

**Create Repository Interface** (`lib/features/categories/domain/repositories/category_repository.dart`):
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> createCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(String id);
}
```

**Create Use Case** (`lib/features/categories/domain/usecases/get_categories.dart`):
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}
```

#### Step 2: Data Layer (Implementation)

**Create Model** (`lib/features/categories/data/models/category_model.dart`):
```dart
import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
    );
  }

  Category toEntity() => this;
}
```

**Create Data Source** (`lib/features/categories/data/datasources/category_remote_datasource.dart`):
```dart
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        '${AppConstants.n8nWebhookUrl}/categories',
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final List<dynamic> data = response.data['categories'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
```

**Implement Repository** (`lib/features/categories/data/repositories/category_repository_impl.dart`):
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      final categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure('Failed to load categories'));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    // Implementation
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    // Implementation
  }
}
```

#### Step 3: Presentation Layer (UI)

**Create States** (`lib/features/categories/presentation/cubit/category_state.dart`):
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
```

**Create Cubit** (`lib/features/categories/presentation/cubit/category_cubit.dart`):
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategories;

  CategoryCubit({required this.getCategories}) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    final result = await getCategories();

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories: categories)),
    );
  }
}
```

**Create Page** (`lib/features/categories/presentation/pages/categories_page.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CategoryCubit>()..loadCategories(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              return ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(
                    leading: Icon(IconData(
                      int.parse(category.icon),
                      fontFamily: 'MaterialIcons',
                    )),
                    title: Text(category.name),
                    tileColor: Color(int.parse(category.color)),
                  );
                },
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

#### Step 4: Register Dependencies

**Update `lib/core/di/injection_container.dart`**:
```dart
// Add imports
import 'package:balance_iq/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:balance_iq/features/categories/data/repositories/category_repository_impl.dart';
import 'package:balance_iq/features/categories/domain/repositories/category_repository.dart';
import 'package:balance_iq/features/categories/domain/usecases/get_categories.dart';
import 'package:balance_iq/features/categories/presentation/cubit/category_cubit.dart';

Future<void> init() async {
  // ... existing code ...

  // Categories Feature
  // Cubit
  sl.registerFactory(() => CategoryCubit(getCategories: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetCategories(sl()));

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
}
```

## Modifying Existing Features

### Example: Add Field to Dashboard

#### 1. Update Domain Entity
```dart
// lib/features/home/domain/entities/dashbaord_summary.dart
class DashboardSummary extends Equatable {
  // ... existing fields ...
  final double monthlyBudget;  // NEW FIELD

  const DashboardSummary({
    // ... existing params ...
    required this.monthlyBudget,
  });

  @override
  List<Object?> get props => [..., monthlyBudget];
}
```

#### 2. Update Data Model
```dart
// lib/features/home/data/models/dashboard_summary_response.dart
class DashboardSummaryResponse extends DashboardSummary {
  const DashboardSummaryResponse({
    // ... existing params ...
    required super.monthlyBudget,
  });

  factory DashboardSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryResponse(
      // ... existing fields ...
      monthlyBudget: (json['monthly_budget'] as num).toDouble(),
    );
  }
}
```

#### 3. Update UI Widget
```dart
// lib/features/home/presentation/widgets/budget_widget.dart
class BudgetWidget extends StatelessWidget {
  final double monthlyBudget;
  final double totalExpenses;

  @override
  Widget build(BuildContext context) {
    final remaining = monthlyBudget - totalExpenses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Monthly Budget', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '৳${remaining.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text('Remaining from ৳${monthlyBudget.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
```

## Database Changes

### Adding a New Table

**Update `core/database/database_helper.dart`**:
```dart
Future _createDB(Database db, int version) async {
  // ... existing tables ...

  // New budgets table
  await db.execute('''
    CREATE TABLE budgets (
      id TEXT PRIMARY KEY,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      period TEXT NOT NULL,
      start_date TEXT NOT NULL,
      end_date TEXT NOT NULL
    )
  ''');

  await db.execute('''
    CREATE INDEX idx_budgets_period ON budgets(period, start_date)
  ''');
}
```

### Database Migration

When changing schema for existing users:
```dart
static const int databaseVersion = 2;  // Increment version

Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: databaseVersion,
    onCreate: _createDB,
    onUpgrade: _onUpgrade,  // Add migration
  );
}

Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Migration from v1 to v2
    await db.execute('ALTER TABLE messages ADD COLUMN category TEXT');
    await db.execute('ALTER TABLE messages ADD COLUMN amount REAL');
  }
}
```

## Adding New API Endpoints

### Update Constants
```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  // ... existing ...
  static String get n8nBudgetUrl =>
      dotenv.get('N8N_BUDGET_URL', fallback: 'https://default-url.com/budget');
}
```

### Add to .env
```
N8N_BUDGET_URL=https://your-n8n-instance.com/webhook-test/budgets
```

### Create Data Source
```dart
abstract class BudgetRemoteDataSource {
  Future<List<BudgetModel>> getBudgets(String userId);
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final Dio dio;

  @override
  Future<List<BudgetModel>> getBudgets(String userId) async {
    final response = await dio.post(
      AppConstants.n8nBudgetUrl,
      data: {'user_id': userId},
    );

    return (response.data['budgets'] as List)
        .map((json) => BudgetModel.fromJson(json))
        .toList();
  }
}
```

## UI Customization

### Changing Theme Colors
```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4A90E2),  // Change this
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    // ...
  );
}
```

### Adding Custom Widget
```dart
// lib/features/home/presentation/widgets/custom_widget.dart
import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title),
        ),
      ),
    );
  }
}
```

## Common Tasks

### Task 1: Add Loading Spinner
```dart
BlocBuilder<SomeCubit, SomeState>(
  builder: (context, state) {
    if (state is SomeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    // ... other states
  },
)
```

### Task 2: Show Error Message
```dart
if (state is SomeError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(state.message),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Task 3: Navigate to New Screen
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const NewPage(),
  ),
);

// Or with named routes
Navigator.of(context).pushNamed('/new-page');
```

### Task 4: Add Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    context.read<DashboardCubit>().loadDashboard();
  },
  child: ListView(...),
)
```

### Task 5: Format Currency
```dart
String formatCurrency(double amount) {
  if (amount >= 1000000) {
    return '৳${(amount / 1000000).toStringAsFixed(1)}M';
  } else if (amount >= 1000) {
    return '৳${(amount / 1000).toStringAsFixed(1)}K';
  } else {
    return '৳${amount.toStringAsFixed(2)}';
  }
}
```

## Best Practices

### 1. State Management
- Keep Cubits small and focused
- Emit new states, don't modify existing
- Use Equatable for state comparison

### 2. Code Organization
- One feature = one folder
- Follow Clean Architecture layers
- Keep widgets small and reusable

### 3. Error Handling
```dart
// Always use Either for operations that can fail
Future<Either<Failure, Data>> fetchData() async {
  try {
    final data = await api.getData();
    return Right(data);
  } on DioException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure('Unexpected error'));
  }
}
```

### 4. Null Safety
```dart
// Use null-aware operators
final name = user?.name ?? 'Guest';

// Use late for delayed initialization
late final AuthCubit authCubit;

// Avoid using ! (bang operator) unless certain
```

### 5. Performance
```dart
// Use const constructors
const Text('Hello');

// Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
);

// Cache expensive computations
late final expensiveValue = _computeExpensiveValue();
```

## Debugging

### Print Statements
```dart
print('Current state: $state');
print('Message count: ${messages.length}');
```

### Flutter DevTools
```bash
# Run app in debug mode
flutter run

# Open DevTools
flutter pub global run devtools
```

### Common Issues

#### Issue 1: State not updating
**Cause**: Not emitting new state object
```dart
// Wrong
state.messages.add(newMessage);
emit(state);

// Correct
emit(state.copyWith(messages: [...state.messages, newMessage]));
```

#### Issue 2: Dependency not found
**Cause**: Not registered in injection_container.dart
```dart
// Solution: Register in init()
sl.registerLazySingleton(() => SomeClass());
```

#### Issue 3: API timeout
**Cause**: Slow network or wrong URL
```dart
// Solution: Increase timeout
Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 60),
  receiveTimeout: const Duration(seconds: 60),
))
```

---

**Next**: Check [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) for what's already built, or [TASKS.md](TASKS.md) for what needs to be done.

---

**Last Updated**: 2025-11-21