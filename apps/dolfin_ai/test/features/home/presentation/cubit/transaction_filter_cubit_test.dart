import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TransactionFilterCubit transactionFilterCubit;

  setUp(() {
    transactionFilterCubit = TransactionFilterCubit();
  });

  tearDown(() {
    transactionFilterCubit.close();
  });

  group('TransactionFilterCubit', () {
    test('initial state has empty filters', () {
      expect(transactionFilterCubit.state, const TransactionFilterState());
      expect(transactionFilterCubit.state.searchQuery, '');
      expect(transactionFilterCubit.state.selectedType, isNull);
      expect(transactionFilterCubit.state.selectedCategory, isNull);
      expect(transactionFilterCubit.state.startDate, isNull);
      expect(transactionFilterCubit.state.endDate, isNull);
    });

    group('updateSearch', () {
      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'updates search query',
        build: () => transactionFilterCubit,
        act: (cubit) => cubit.updateSearch('test query'),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.searchQuery, 'searchQuery', 'test query'),
        ],
      );

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'updates search query multiple times',
        build: () => transactionFilterCubit,
        act: (cubit) {
          cubit.updateSearch('first');
          cubit.updateSearch('second');
        },
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.searchQuery, 'searchQuery', 'first'),
          isA<TransactionFilterState>()
              .having((s) => s.searchQuery, 'searchQuery', 'second'),
        ],
      );
    });

    group('updateType', () {
      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'updates transaction type',
        build: () => transactionFilterCubit,
        act: (cubit) => cubit.updateType('EXPENSE'),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.selectedType, 'selectedType', 'EXPENSE'),
        ],
      );

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'clears transaction type when null',
        build: () => transactionFilterCubit,
        seed: () => const TransactionFilterState(selectedType: 'EXPENSE'),
        act: (cubit) => cubit.updateType(null),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.selectedType, 'selectedType', isNull),
        ],
      );
    });

    group('updateCategory', () {
      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'updates category',
        build: () => transactionFilterCubit,
        act: (cubit) => cubit.updateCategory('Food'),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.selectedCategory, 'selectedCategory', 'Food'),
        ],
      );

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'clears category when null',
        build: () => transactionFilterCubit,
        seed: () => const TransactionFilterState(selectedCategory: 'Food'),
        act: (cubit) => cubit.updateCategory(null),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.selectedCategory, 'selectedCategory', isNull),
        ],
      );
    });

    group('updateDateRange', () {
      final startDate = DateTime(2025, 1, 1);
      final endDate = DateTime(2025, 1, 31);

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'updates date range',
        build: () => transactionFilterCubit,
        act: (cubit) => cubit.updateDateRange(startDate, endDate),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.startDate, 'startDate', startDate)
              .having((s) => s.endDate, 'endDate', endDate),
        ],
      );

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'clears date range when both are null',
        build: () => transactionFilterCubit,
        seed: () => TransactionFilterState(
          startDate: startDate,
          endDate: endDate,
        ),
        act: (cubit) => cubit.updateDateRange(null, null),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.startDate, 'startDate', isNull)
              .having((s) => s.endDate, 'endDate', isNull),
        ],
      );

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'updates only start date',
        build: () => transactionFilterCubit,
        act: (cubit) => cubit.updateDateRange(startDate, null),
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.startDate, 'startDate', startDate)
              .having((s) => s.endDate, 'endDate', isNull),
        ],
      );
    });

    group('clearAllFilters', () {
      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'resets all filters to initial state',
        build: () => transactionFilterCubit,
        seed: () => TransactionFilterState(
          searchQuery: 'test',
          selectedType: 'EXPENSE',
          selectedCategory: 'Food',
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 31),
        ),
        act: (cubit) => cubit.clearAllFilters(),
        expect: () => [
          const TransactionFilterState(),
        ],
      );

      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'clearing already empty filters emits initial state',
        build: () => transactionFilterCubit,
        act: (cubit) => cubit.clearAllFilters(),
        expect: () => [
          const TransactionFilterState(),
        ],
      );
    });

    group('combined filter updates', () {
      blocTest<TransactionFilterCubit, TransactionFilterState>(
        'applies multiple filters sequentially',
        build: () => transactionFilterCubit,
        act: (cubit) {
          cubit.updateSearch('groceries');
          cubit.updateType('EXPENSE');
          cubit.updateCategory('Food');
          cubit.updateDateRange(DateTime(2025, 1, 1), DateTime(2025, 1, 31));
        },
        expect: () => [
          isA<TransactionFilterState>()
              .having((s) => s.searchQuery, 'searchQuery', 'groceries'),
          isA<TransactionFilterState>()
              .having((s) => s.selectedType, 'selectedType', 'EXPENSE'),
          isA<TransactionFilterState>()
              .having((s) => s.selectedCategory, 'selectedCategory', 'Food'),
          isA<TransactionFilterState>()
              .having((s) => s.startDate, 'startDate', isNotNull)
              .having((s) => s.endDate, 'endDate', isNotNull),
        ],
      );
    });
  });
}
