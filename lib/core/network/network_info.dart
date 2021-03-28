import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  const NetworkInfo();
}

class NetworkInfoImpl extends NetworkInfo {
  final InternetConnectionChecker dataConnectionChecker;
  const NetworkInfoImpl(this.dataConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
