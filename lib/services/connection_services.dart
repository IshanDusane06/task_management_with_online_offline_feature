import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile);
      _connectionStatusController.add(isConnected);
    });
  }

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  static Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
