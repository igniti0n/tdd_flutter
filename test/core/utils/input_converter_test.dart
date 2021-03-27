import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/util/input_converter.dart';

void main() {
  final InputConverter inputConverter = InputConverter();

  test(
    'should return an unsigned integer when passed unsigned integer as String',
    () async {
      // arrange
      final String text = "4";
      // act
      final result = inputConverter.stringToUnsignedInt(text);
      // assert
      expect(
        result,
        equals(Right(4)),
      );
    },
  );

  test(
    'should return a InputFailure when passed non integer String',
    () async {
      // arrange
      final String text = "abcd";
      // act
      final result = inputConverter.stringToUnsignedInt(text);
      // assert
      expect(
        result,
        equals(Left(InputFailure())),
      );
    },
  );

  test(
    'should return a InputFailure when passed a signed integer',
    () async {
      // arrange
      final String text = "-4";
      // act
      final result = inputConverter.stringToUnsignedInt(text);
      // assert
      expect(
        result,
        equals(Left(InputFailure())),
      );
    },
  );
}
