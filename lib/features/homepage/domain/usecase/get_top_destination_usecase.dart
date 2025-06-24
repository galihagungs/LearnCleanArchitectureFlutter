import 'package:dartz/dartz.dart';
import 'package:travel_app_clean_architecture/core/error/failures.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/repositories/destination_repository.dart';

class GetTopDestinationUsecase {
  final DestinationRepository _repository;
  GetTopDestinationUsecase(this._repository);

  Future<Either<Failure, List<DestinationEntity>>> call() {
    return _repository.top();
  }
}
