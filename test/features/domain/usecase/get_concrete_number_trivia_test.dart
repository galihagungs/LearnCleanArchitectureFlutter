import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_learn_cleanaarchitecture/core/error/failures.dart';
import 'package:flutter_learn_cleanaarchitecture/features/number_trivia/domain/entities/number_trivia_entities.dart';
import 'package:flutter_learn_cleanaarchitecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:flutter_learn_cleanaarchitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositories {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTiviaEntities(number: 1, text: 'test');

  test('should get trivia for the number from the repository', () async {
    // arrange
    when(
      mockNumberTriviaRepository.getConcreteNumberTrivia(Random().nextInt(100)),
    ).thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase(Params(number: tNumber));
    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
