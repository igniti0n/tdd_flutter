import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  const NetworkInfo();
  }


class NetworkInfoImpl extends NetworkInfo {

  final DataConnectionChecker dataConnectionChecker;
  const NetworkInfoImpl(this.dataConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}