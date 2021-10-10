// ignore_for_file: prefer_const_declarations

import 'package:test/test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/simple_result.dart';

class MyFailure implements Exception {
  @override
  String toString() => 'MyFailure';
}

void main() {
  test('toString for a success object', () {
    const valueString = 'A String';
    final simpleStringResult = const Result.success(valueString);
    expect(simpleStringResult.toString(), 'Success: $valueString');
  });
  test('toString for a success null object', () {
    final simpleStringResult = const Result.success(null);
    expect(simpleStringResult.toString(), 'Success: (null)');
  });

  test('toString for a failure object', () {
    final simpleStringResult = Result.failure(MyFailure());
    expect(simpleStringResult.toString(), 'Failure: MyFailure');
  });
  test('toString for a failure null object', () {
    final simpleStringResult = const Result.failure(null);
    expect(simpleStringResult.toString(), 'Failure: (null)');
  });
}
