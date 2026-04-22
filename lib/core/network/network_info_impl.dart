import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/foundation.dart';

import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    // `internet_connection_checker_plus` relies on platform-specific connectivity
    // checks that are not reliable on Flutter Web. On web, let the HTTP client
    // attempt the request and handle failures (CORS, DNS, offline) normally.
    if (kIsWeb) return true;
    return connectionChecker.hasInternetAccess;
  }
}
