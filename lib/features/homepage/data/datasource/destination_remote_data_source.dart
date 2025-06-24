import 'dart:convert';

import 'package:travel_app_clean_architecture/api/urls.dart';
import 'package:travel_app_clean_architecture/core/error/exception.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/models/destination_model.dart';
import 'package:http/http.dart' as http;

abstract class DestinationRemoteDataSource {
  Future<List<DestinationModel>> all();
  Future<List<DestinationModel>> top();
  Future<List<DestinationModel>> search(String query);
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final http.Client client;
  DestinationRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DestinationModel>> all() async {
    Uri uri = Uri.parse('${Urls.base}/destination/all.php');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      List listdata = jsonDecode(response.body);
      List<DestinationModel> data =
          listdata.map((e) => DestinationModel.fromJson(e)).toList();
      return data;
    } else if (response.statusCode == 404) {
      throw NotFoundException(response.body);
    } else {
      throw ServerException(response.body);
    }
  }

  @override
  Future<List<DestinationModel>> search(String query) async {
    Uri uri = Uri.parse('${Urls.base}/destination/search.php');
    final response = await client
        .post(uri, body: {'query': query})
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      List listdata = jsonDecode(response.body);
      List<DestinationModel> data =
          listdata.map((e) => DestinationModel.fromJson(e)).toList();
      return data;
    } else if (response.statusCode == 404) {
      throw NotFoundException(response.body);
    } else {
      throw ServerException(response.body);
    }
  }

  @override
  Future<List<DestinationModel>> top() async {
    Uri uri = Uri.parse('${Urls.base}/destination/top.php');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      List listdata = jsonDecode(response.body);
      List<DestinationModel> data =
          listdata.map((e) => DestinationModel.fromJson(e)).toList();
      return data;
    } else if (response.statusCode == 404) {
      throw NotFoundException(response.body);
    } else {
      throw ServerException(response.body);
    }
  }
}
