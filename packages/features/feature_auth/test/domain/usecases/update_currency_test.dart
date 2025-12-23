import 'package:dartz/dartz.dart';
import 'package:feature_auth/domain/usecases/update_currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late UpdateCurrency useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UpdateCurrency(mockAuthRepository);
  });

  const tCurrency = 'USD';

  test('should call updateCurrency from the repository', () async {
    // arrange
    when(() => mockAuthRepository.updateCurrency(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await useCase(tCurrency);

    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.updateCurrency(tCurrency));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
