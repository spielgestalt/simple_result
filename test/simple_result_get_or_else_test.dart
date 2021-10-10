import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

abstract class ValueFailure<T> implements Exception {}

class EmptyFailure<T> extends ValueFailure<T> {}

class ExceedingLengthFailure<T> extends ValueFailure<T> {}

class WrongCharacter<T> extends ValueFailure<T> {}

Result<String, ValueFailure<String>> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return Result.success(input);
  } else {
    return Result.failure(ExceedingLengthFailure());
  }
}

Result<String?, ValueFailure<String>> validateCharacters(String? input) {
  if (input!.contains("-")) {
    return Result.failure(WrongCharacter());
  } else {
    return Result.success(input);
  }
}

Result<String?, ValueFailure<String>> validateStringNotEmpty(
  String? input,
) {
  if (input!.isEmpty) {
    return Result.failure(EmptyFailure());
  } else {
    return Result.success(input);
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
