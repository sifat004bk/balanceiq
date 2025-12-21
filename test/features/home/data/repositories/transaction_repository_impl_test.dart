import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/features/home/data/models/transaction_model.dart';
import 'package:balance_iq/features/home/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mock_datasources.dart';

void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionSearchDataSource mockSearchDataSource;

  setUp(() {
    mockSearchDataSource = MockTransactionSearchDataSource();
    repository = TransactionRepositoryImpl(
      remoteDataSource: mockSearchDataSource,
    );
  });

  group('searchTransactions', () {
    final tSearchResponse = TransactionSearchResponse(
      success: true,
      count: 1,
      transactions: [
        TransactionModel(
          transactionId: 1,
          type: 'expense',
          amount: 100.0,
          category: 'Food',
          description: 'Lunch',
          transactionDate: DateTime(2023, 1, 1),
          createdAt: DateTime(2023, 1, 1),
          relevanceScore: 1.0,
          totalMatches: 1,
        )
      ],
    );

    test('should return TransactionSearchResult when remote call is successful',
        () async {
      // Arrange
      when(() => mockSearchDataSource.searchTransactions(
              search: any(named: 'search')))
          .thenAnswer((_) async => tSearchResponse);

      // Act
      final result = await repository.searchTransactions(search: 'test');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right'),
        (r) {
          expect(r.success, true);
          expect(r.transactions.length, 1);
          expect(r.transactions.first.transactionId, 1);
        },
      );

      verify(() => mockSearchDataSource.searchTransactions(search: 'test'))
          .called(1);
    });

    test('should return ServerFailure when remote call throws exception',
        () async {
      // Arrange
      when(() => mockSearchDataSource.searchTransactions(
          search: any(named: 'search'))).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.searchTransactions(search: 'test');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Expected Left'),
      );
    });
  });
}
