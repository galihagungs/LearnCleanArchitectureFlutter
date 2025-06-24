// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class Networkinfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements Networkinfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> isConnected() async {
    final connectivityRes = await connectivity.checkConnectivity();
    if (connectivityRes[0] == ConnectivityResult.mobile ||
        connectivityRes[0] == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
