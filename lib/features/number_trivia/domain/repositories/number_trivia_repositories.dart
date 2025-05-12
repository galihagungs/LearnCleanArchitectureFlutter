import 'package:dartz/dartz.dart';
import 'package:flutter_learn_cleanaarchitecture/core/error/failures.dart';
import 'package:flutter_learn_cleanaarchitecture/features/number_trivia/domain/entities/number_trivia_entities.dart';

abstract class NumberTriviaRepositories {
  Future<Either<Failure, NumberTiviaEntities>> getConcreteNumberTrivia(
    int number,
  );
  Future<Either<Failure, NumberTiviaEntities>> getRandomNumberTrivia();
}
