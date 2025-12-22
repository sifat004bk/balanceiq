import 'package:dolfin_core/error/failures.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:balance_iq/features/home/domain/usecases/delete_transaction.dart';
import 'package:balance_iq/features/home/domain/usecases/search_transactions.dart';
import 'package:balance_iq/features/home/domain/usecases/update_transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTransactions extends Mock implements SearchTransactions {}

class MockUpdateTransaction extends Mock implements UpdateTransaction {}

class MockDeleteTransaction extends Mock implements DeleteTransaction {}

class FakeTransaction extends Fake implements Transaction {}

void main() {
  late TransactionsCubit transactionsCubit;
  late MockSearchTransactions mockSearchTransactions;
  late MockUpdateTransaction mockUpdateTransaction;
  late MockDeleteTransaction mockDeleteTransaction;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockSearchTransactions = MockSearchTransactions();
    mockUpdateTransaction = MockUpdateTransaction();
    mockDeleteTransaction = MockDeleteTransaction();
    transactionsCubit = TransactionsCubit(
      searchTransactions: mockSearchTransactions,
      updateTransactionUseCase: mockUpdateTransaction,
      deleteTransactionUseCase: mockDeleteTransaction,
    );
  });

  tearDown(() {
    transactionsCubit.close();
  });

  group('TransactionsCubit', () {
    final tTransaction = Transaction(
      transactionId: 1,
      amount: 100.0,
      description: 'Test transaction',
      category: 'Food',
      type: 'EXPENSE',
      transactionDate: DateTime(2025, 1, 15),
      createdAt: DateTime(2025, 1, 15),
    );

    final tTransactionList = [tTransaction];
    final tSearchResult = TransactionSearchResult(
      success: true,
      count: tTransactionList.length,
      transactions: tTransactionList,
    );

    test('initial state is TransactionsInitial', () {
      expect(transactionsCubit.state, isA<TransactionsInitial>());
    });

    group('loadTransactions', () {
      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsLoaded] when successful',
        build: () {
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: any(named: 'limit'),
              )).thenAnswer((_) async => Right(tSearchResult));
          return transactionsCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsLoaded>()
              .having((s) => s.transactions, 'transactions', tTransactionList)
              .having((s) => s.hasReachedMax, 'hasReachedMax', true),
        ],
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsLoaded] with filters',
        build: () {
          when(() => mockSearchTransactions(
                search: 'test',
                category: 'Food',
                type: 'expense',
                startDate: '2025-01-01',
                endDate: '2025-01-31',
                minAmount: 10.0,
                maxAmount: 1000.0,
                limit: 50,
              )).thenAnswer((_) async => Right(tSearchResult));
          return transactionsCubit;
        },
        act: (cubit) => cubit.loadTransactions(
          search: 'test',
          category: 'Food',
          type: 'expense',
          startDate: '2025-01-01',
          endDate: '2025-01-31',
          minAmount: 10.0,
          maxAmount: 1000.0,
        ),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockSearchTransactions(
                search: 'test',
                category: 'Food',
                type: 'expense',
                startDate: '2025-01-01',
                endDate: '2025-01-31',
                minAmount: 10.0,
                maxAmount: 1000.0,
                limit: 50,
              )).called(1);
        },
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsError] when search fails',
        build: () {
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: any(named: 'limit'),
              )).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return transactionsCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsError>()
              .having((s) => s.message, 'message', 'Server error'),
        ],
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'sets hasReachedMax to false when transactions equal limit',
        build: () {
          final fiftyTransactions = List.generate(
            50,
            (i) => Transaction(
              transactionId: i,
              amount: 100.0,
              description: 'Transaction $i',
              category: 'Food',
              type: 'EXPENSE',
              transactionDate: DateTime(2025, 1, 15),
              createdAt: DateTime(2025, 1, 15),
            ),
          );
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: any(named: 'limit'),
              )).thenAnswer((_) async => Right(
                TransactionSearchResult(
                  success: true,
                  count: 50,
                  transactions: fiftyTransactions,
                ),
              ));
          return transactionsCubit;
        },
        act: (cubit) => cubit.loadTransactions(),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsLoaded>()
              .having((s) => s.hasReachedMax, 'hasReachedMax', false),
        ],
      );
    });

    group('updateTransaction', () {
      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsLoaded] when successful',
        build: () {
          when(() => mockUpdateTransaction(any()))
              .thenAnswer((_) async => const Right(unit));
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: any(named: 'limit'),
              )).thenAnswer((_) async => Right(tSearchResult));
          return transactionsCubit;
        },
        act: (cubit) => cubit.updateTransaction(tTransaction),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockUpdateTransaction(tTransaction)).called(1);
        },
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsError] when update fails',
        build: () {
          when(() => mockUpdateTransaction(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Update failed')),
          );
          return transactionsCubit;
        },
        act: (cubit) => cubit.updateTransaction(tTransaction),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsError>()
              .having((s) => s.message, 'message', 'Update failed'),
        ],
      );
    });

    group('deleteTransaction', () {
      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsLoaded] when successful',
        build: () {
          when(() => mockDeleteTransaction(any()))
              .thenAnswer((_) async => const Right(unit));
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: any(named: 'limit'),
              )).thenAnswer((_) async => Right(tSearchResult));
          return transactionsCubit;
        },
        act: (cubit) => cubit.deleteTransaction(1),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockDeleteTransaction(1)).called(1);
        },
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'emits [TransactionsLoading, TransactionsError] when delete fails',
        build: () {
          when(() => mockDeleteTransaction(any())).thenAnswer(
            (_) async => const Left(ServerFailure('Delete failed')),
          );
          return transactionsCubit;
        },
        act: (cubit) => cubit.deleteTransaction(1),
        expect: () => [
          isA<TransactionsLoading>(),
          isA<TransactionsError>()
              .having((s) => s.message, 'message', 'Delete failed'),
        ],
      );
    });

    group('loadMoreTransactions', () {
      blocTest<TransactionsCubit, TransactionsState>(
        'does nothing when state is not TransactionsLoaded',
        build: () => transactionsCubit,
        act: (cubit) => cubit.loadMoreTransactions(),
        expect: () => [],
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'does nothing when hasReachedMax is true',
        build: () => transactionsCubit,
        seed: () => const TransactionsLoaded(
          transactions: [],
          hasReachedMax: true,
        ),
        act: (cubit) => cubit.loadMoreTransactions(),
        expect: () => [],
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'loads more transactions successfully',
        build: () {
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: 100,
              )).thenAnswer((_) async => Right(tSearchResult));
          return transactionsCubit;
        },
        seed: () => TransactionsLoaded(
          transactions: tTransactionList,
          hasReachedMax: false,
        ),
        act: (cubit) => cubit.loadMoreTransactions(),
        expect: () => [
          isA<TransactionsLoaded>()
              .having((s) => s.isMoreLoading, 'isMoreLoading', true),
          isA<TransactionsLoaded>()
              .having((s) => s.isMoreLoading, 'isMoreLoading', false),
        ],
      );

      blocTest<TransactionsCubit, TransactionsState>(
        'handles error when loading more transactions',
        build: () {
          when(() => mockSearchTransactions(
                search: any(named: 'search'),
                category: any(named: 'category'),
                type: any(named: 'type'),
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
                minAmount: any(named: 'minAmount'),
                maxAmount: any(named: 'maxAmount'),
                limit: 100,
              )).thenAnswer(
            (_) async => const Left(ServerFailure('Load more failed')),
          );
          return transactionsCubit;
        },
        seed: () => TransactionsLoaded(
          transactions: tTransactionList,
          hasReachedMax: false,
        ),
        act: (cubit) => cubit.loadMoreTransactions(),
        expect: () => [
          isA<TransactionsLoaded>()
              .having((s) => s.isMoreLoading, 'isMoreLoading', true),
          isA<TransactionsLoaded>()
              .having((s) => s.isMoreLoading, 'isMoreLoading', false)
              .having((s) => s.transactions, 'transactions', tTransactionList),
        ],
      );
    });
  });
}
