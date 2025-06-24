import 'package:dartz/dartz.dart';
import 'package:travel_app_clean_architecture/core/error/failures.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/repositories/destination_repository.dart';

class GetSearchDestinationUsecase {
  final DestinationRepository _repository;
  GetSearchDestinationUsecase(this._repository);

  Future<Either<Failure, List<DestinationEntity>>> call(String query) {
    return _repository.search(query);
  }
}
