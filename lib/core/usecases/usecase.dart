import 'package:dartz/dartz.dart';
import 'package:FlutterDex/core/error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
