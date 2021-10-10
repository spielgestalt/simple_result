// ignore_for_file: prefer_const_declarations

import 'package:equatable/equatable.dart';
import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

class MyFailure extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class Failure1 extends MyFailure {
  @override
  List<Object> get props => [];
}

class Failure2 extends MyFailure {
  @override
  List<Object> get props => [];
}

void main() {
  group('with two equal results', () {
    test('equal success results should be equal', () {
      const resultString = 'abc';
      final result1 = const Result<String, MyFailure>.success(resultString);
      final result2 = const Result<String, MyFailure>.success(resultString);
      expect(result1, result2);
    });
    test('equal failure results should be equal', () {
      final result1 = Result<String, MyFailure>.failure(MyFailure());
      final result2 = Result<String, MyFailure>.failure(MyFailure());
      expect(result1, result2);
    });
    test('unequal success results should not be equal', () {
      const resultString = 'abc';
      const resultString2 = 'def';
      final result1 = const Result<String, MyFailure>.success(resultString);
      final result2 = const Result<String, MyFailure>.success(resultString2);
      expect(result1, isNot(result2));
    });
    test('unequal failure results should not be equal', () {
      final result1 = Result<String, MyFailure>.failure(Failure1());
      final result2 = Result<String, MyFailure>.failure(Failure2());
      expect(result1, isNot(result2));
    });
  });
}
