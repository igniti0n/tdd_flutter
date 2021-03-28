// @dart=2.9

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfo;

  group('connected to internet', () {
    setUp(() {
      mockDataConnectionChecker = MockDataConnectionChecker();
      networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
    });
    test('should forward the call DataConnectionChecker.isConnected', () async {
      final tReturnedFuture = Future.value(true);
      //arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tReturnedFuture);
      //act
      final result = networkInfo.isConnected;

      //assert
      verify(mockDataConnectionChecker.hasConnection).called(1);
      expect(result, tReturnedFuture);
    });
  });
}
