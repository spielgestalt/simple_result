import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

abstract class ValueFailure<T> implements Exception {}

class EmptyFailure<T> extends ValueFailure<T> {}

class ExceedingLengthFailure<T> extends ValueFailure<T> {}

class WrongCharacter<T> extends ValueFailure<T> {}

SimpleResult<String, ValueFailure<String>> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return SimpleResult.success(input);
  } else {
    return SimpleResult.failure(ExceedingLengthFailure());
  }
}

SimpleResult<String?, ValueFailure<String>> validateCharacters(String? input) {
  if (input!.contains("-")) {
    return SimpleResult.failure(WrongCharacter());
  } else {
    return SimpleResult.success(input);
  }
}

SimpleResult<String?, ValueFailure<String>> validateStringNotEmpty(
    String? input) {
  if (input!.isEmpty) {
    return SimpleResult.failure(EmptyFailure());
  } else {
    return SimpleResult.success(input);
  }
}

void main() {
  const correctString = "12345";
  const maxLength = 10;
  const tooLongString = "12345678901";
  const errorMessage = 'this is an error';

  group('using a correct sentence', () {
    test('should return the sentence', () {
      final result = validateMaxStringLength(correctString, maxLength)
          .getOrElse(() => 'asdf');
      expect(result, correctString);
    });
  });
  group('using too long sentences', () {
    test('should get the failure string', () {
      final result = validateMaxStringLength(tooLongString, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateCharacters)
          .getOrElse(() => errorMessage);
      expect(result, errorMessage);
    });
  });
}
