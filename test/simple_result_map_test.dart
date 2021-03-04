import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

class Example {
  final String username;

  Example({required this.username});
}

abstract class Failure implements Exception {}

class ExampleFailure implements Failure {}

void main() {
  group('with initialized examples', () {
    final exampleObject = Example(username: 'bob');

    test('should map to a new typed result', () {
      final exampleResult =
          SimpleResult<Example, Failure>.success(exampleObject);
      final stringResult =
          exampleResult.map((example) => 'Hello ${example!.username}');
      expect(stringResult, isA<SimpleResult<String, Failure>>());

      final result = stringResult.when(success: (name) => name, failure: null);
      expect(result, 'Hello bob');

      final boolResult = exampleResult.map((example) => true);
      expect(boolResult, isA<SimpleResult<bool, Failure>>());

      final errorResult =
          SimpleResult<Example, Failure>.failure(ExampleFailure());
      expect(errorResult, isA<SimpleResult<Example, Failure>>());
      final errorStringResult =
          errorResult.map((value) => 'Error should be null');
      expect(errorStringResult, isA<SimpleResult<String, Failure?>>());
      final errorMessage = errorStringResult.when(
          success: (value) => 'Shoult not be!',
          failure: (_) => 'ERROR Message');
      expect(errorMessage, 'ERROR Message');
    });
    group('with a success result', () {
      final exampleResult =
          SimpleResult<Example, Failure>.success(exampleObject);

      test('should return isSuccess with the value', () {
        expect(exampleResult.isSuccess, isTrue);

        expect(exampleResult.success, exampleObject);
      });
      test('should return isFailure false and null as failure object', () {
        expect(exampleResult.isFailure, isFalse);
        expect(exampleResult.failure, isNull);
      });
      test('should not crash with a null as succes or failure case', () {
        final result = exampleResult.when(success: null, failure: null);
        expect(result, isNull);
      });
      test('should not crash with a null as succes or failure case', () {
        final errorResult =
            SimpleResult<Example, Failure>.failure(ExampleFailure());
        final result = errorResult.when(success: null, failure: null);
        expect(result, isNull);
      });
    });
    group('with a failure result', () {
      final exampleResult =
          SimpleResult<Example, Failure>.failure(ExampleFailure());
      test('should return isSuccess false with the value as null', () {
        expect(exampleResult.isSuccess, isFalse);

        expect(exampleResult.success, null);
      });
      test('should return isFailure true and the failure object', () {
        expect(exampleResult.isFailure, isTrue);
        expect(exampleResult.failure, isA<ExampleFailure>());
      });
    });
    group('without declaring types', () {
      test('should have concrete value type and dynamic failure', () {
        final myResult = SimpleResult.success('Some value');

        expect(myResult, isA<SimpleResult<String, dynamic>>());
      });
      test('should have concrete failure type and dynamic value', () {
        final myErrorResult = SimpleResult.failure(ExampleFailure());
        expect(myErrorResult, isA<SimpleResult<dynamic, ExampleFailure>>());
      });
    });
  });
}
