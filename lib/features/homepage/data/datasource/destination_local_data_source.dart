import 'dart:convert';

import 'package:travel_app_clean_architecture/core/error/exception.dart';
import 'package:travel_app_clean_architecture/features/homepage/data/models/destination_model.dart';
import 'package:travel_app_clean_architecture/features/homepage/domain/entities/destination_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cacheAllDestinationKey = 'all_destination';

abstract class DestinationLocalDataSource {
  Future<List<DestinationModel>> all();
  Future<bool> cacheAll(List<DestinationModel> data);
}

class DestinationLocalDataSourceImpl implements DestinationLocalDataSource {
  final SharedPreferences sharedPreferences;
  DestinationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<DestinationModel>> all() async {
    String? jsonString = sharedPreferences.getString(cacheAllDestinationKey);
    if (jsonString != null) {
      List listMap = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
      return listMap.map((e) => DestinationModel.fromJson(e)).toList();
    } else {
      throw CacheException('No cached data found ');
    }
  }

  @override
  Future<bool> cacheAll(List<DestinationModel> data) {
    List<Map<String, dynamic>> listMap = data.map((e) => e.toJson()).toList();
    String allData = jsonEncode(listMap);
    return sharedPreferences.setString(cacheAllDestinationKey, allData);
  }
}
