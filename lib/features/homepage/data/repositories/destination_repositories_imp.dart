// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:travel_app_clean_architecture/core/error/exception.dart';

import 'package:travel_app_clean_architecture/core/error/failures.dart';
import 'package:travel_app_clean_architecture/core/platform/networkinfo.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/datasource/destination_local_data_source.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/datasource/destination_remote_data_source.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/repositories/destination_repository.dart';

class DestinationRepositoriesImp implements DestinationRepository {
  final Networkinfo networkinfo;
  final DestinationRemoteDataSource remoteDataSource;
  final DestinationLocalDataSource localDataSource;

  DestinationRepositoriesImp({
    required this.networkinfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<DestinationEntity>>> all() async {
    bool isConnected = await networkinfo.isConnected();

    if (isConnected) {
      try {
        final result = await remoteDataSource.all();
        await localDataSource.cacheAll(result);
        List<DestinationEntity> data = result.map((e) => e.toEntity).toList();
        return Right(data);
      } on TimeoutException {
        return Left(TimeOutFailure('Request timed out'));
      } on NotFoundException {
        return const Left(NotFoundFailure('Data not found'));
      } on ServerException catch (e) {
        return Left(ServerFailure("Server Error"));
      }
    } else {
      try {
        final result = await localDataSource.all();
        return Right(result.map((e) => e.toEntity).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('No cached data found'));
      }
    }
  }

  @override
  Future<Either<Failure, List<DestinationEntity>>> search(String query) async {
    try {
      final result = await remoteDataSource.search(query);
      List<DestinationEntity> data = result.map((e) => e.toEntity).toList();
      return Right(data);
    } on TimeoutException {
      return Left(TimeOutFailure('Request timed out'));
    } on NotFoundException {
      return const Left(NotFoundFailure('Data not found'));
    } on ServerException catch (e) {
      return Left(ServerFailure("Server Error"));
    } on SocketException catch (e) {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<DestinationEntity>>> top() async {
    try {
      final result = await remoteDataSource.top();
      List<DestinationEntity> data = result.map((e) => e.toEntity).toList();
      return Right(data);
    } on TimeoutException {
      return Left(TimeOutFailure('Request timed out'));
    } on NotFoundException {
      return const Left(NotFoundFailure('Data not found'));
    } on ServerException catch (e) {
      return Left(ServerFailure("Server Error"));
    } on SocketException catch (e) {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
