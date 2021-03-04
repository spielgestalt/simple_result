import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

class Example {
  final String username;

  Example({required this.username});
}

abstract class Failure implements Exception {}

class ExampleFailure implements Failure {}

void main() {
  const exampleUsername = 'Bob';
  final example = Example(username: exampleUsername);
  group('with defined generic results', () {
    test('should return success', () {
      final successResult = SimpleResult.success(example);

      final result = successResult.when(
          success: (example) => example!.username, failure: (_) => 'failure');
      expect(result, isA<String>());
    });
  });
  group('with defined results', () {
    test('should return a valid type', () {
      final successResult = SimpleResult<Example, Failure>.success(example);
      final result = successResult.when(
          success: (example) => example, failure: (_) => null)!;
      expect(result, isA<Example>());
      expect(result.username, exampleUsername);
    });
  });
}
