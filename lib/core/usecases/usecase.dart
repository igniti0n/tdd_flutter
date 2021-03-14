import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd/core/error/failure.dart';

abstract class Usecase<Type, Param> {
  const Usecase();
  Future<Either<Failure, Type>> call(Param param);
}
