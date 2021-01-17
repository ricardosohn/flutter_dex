import 'package:FlutterDex/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, String> validateString(String str) {
    if (!str.contains(RegExp(r'[^a-zA-Z]'))) {
      return Right(str);
    } else {
      return Left(InputConverterFailure());
    }
  }
}

class InputConverterFailure extends Failure {}
