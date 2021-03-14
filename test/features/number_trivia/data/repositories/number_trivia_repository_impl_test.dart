import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/platform/network_info.dart';
import 'package:tdd/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:tdd/features/number_trivia/data/datasources/network_data_source.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockNetworkDataSource extends Mock implements NetworkDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockLocalDataSource mockLocalDataSource;
  MockNetworkDataSource mockNetworkDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockNetworkDataSource = MockNetworkDataSource();
    mockLocalDataSource = MockLocalDataSource();
  });
}
