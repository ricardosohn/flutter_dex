void main() {}
// import 'package:FlutterDex/core/network/network_info.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
//
// class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}
//
// void main() {
//   NetworkInfoImpl networkInfo;
//   MockDataConnectionChecker mockDataConnectionChecker;
//
//   setUp(() {
//     mockDataConnectionChecker = MockDataConnectionChecker();
//     networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
//   });
//
//   group('isConnected', () {
//     test('should forward the call to DataConnectionChecker.hasConnection',
//         () async {
//       final tHasConnectionFuture = Future.value(true);
//       //arrange
//       when(mockDataConnectionChecker.hasConnection)
//           .thenAnswer((_) => tHasConnectionFuture);
//       //act
//       final result = networkInfo.isConnected;
//       //assert
//       verify(mockDataConnectionChecker.hasConnection);
//       expect(result, tHasConnectionFuture);
//     });
//   });
// }
