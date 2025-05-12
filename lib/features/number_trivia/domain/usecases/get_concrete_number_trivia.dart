import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_learn_cleanaarchitecture/core/error/failures.dart';
import 'package:flutter_learn_cleanaarchitecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';

import '../entities/number_trivia_entities.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepositories repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTiviaEntities>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object> get props => [number];
}
