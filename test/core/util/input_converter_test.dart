import 'package:dartz/dartz.dart';
import 'package:flutter_dex/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('string is valid', () {
    test('''should return true when the string does not contain any numbers 
    or special characters''', () async {
      //arrange
      final tStr = 'Charmander';
      //act
      final result = inputConverter.validateString(tStr);
      //assert
      expect(result, Right(tStr));
    });
  });

  group('string is invalid', () {
    test('should return failure when the string contains invalid characters',
        () async {
      //arrange
      final tStr = 'Charmander1!#1a';
      //act
      final result = inputConverter.validateString(tStr);
      //assert
      expect(result, Left(InputConverterFailure()));
    });
  });
}
