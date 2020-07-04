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

SimpleResult<String, ValueFailure<String>> validateCharacters(String input) {
  if (input.contains("-")) {
    return SimpleResult.failure(WrongCharacter());
  } else {
    return SimpleResult.success(input);
  }
}

SimpleResult<String, ValueFailure<String>> validateStringNotEmpty(
    String input) {
  if (input.isEmpty) {
    return SimpleResult.failure(EmptyFailure());
  } else {
    return SimpleResult.success(input);
  }
}

void main() {
  const correctString = "12345";
  const wrongCharacterString = "123-456";
  const emptyString = "";
  const maxLength = 10;
  const tooLongString = "12345678901";
  const wrongCharacterAndTooLong = "12345-67890";

  group('using a correct sentence', () {
    test('should flatMap to success', () {
      final result = validateMaxStringLength(correctString, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateCharacters);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.failure, isNull);
      expect(result.success, correctString);
    });
  });
  group('using too long sentences', () {
    test('should flatMap to failure', () {
      final result = validateMaxStringLength(tooLongString, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateCharacters);
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.failure.runtimeType,
          ExceedingLengthFailure<String>().runtimeType);
      expect(result.failure.runtimeType,
          isNot(WrongCharacter<String>().runtimeType));
    });
  });
  group('using wrong characters', () {
    test('should flatMap to failure', () {
      final result = validateMaxStringLength(wrongCharacterString, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateCharacters);
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.failure.runtimeType, WrongCharacter<String>().runtimeType);
      expect(result.failure.runtimeType,
          isNot(ExceedingLengthFailure<String>().runtimeType));
    });
  });
  group('using empty sentences', () {
    test('should flatMap to failure', () {
      final result = validateMaxStringLength(emptyString, maxLength)
          .flatMap(validateStringNotEmpty)
          .flatMap(validateCharacters);
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.failure.runtimeType, EmptyFailure<String>().runtimeType);
      expect(result.failure.runtimeType,
          isNot(ExceedingLengthFailure<String>().runtimeType));
    });
  });
  group('using a combination of too long and wrong characters', () {
    test('should flatMap to failure', () {
      final result =
          validateMaxStringLength(wrongCharacterAndTooLong, maxLength)
              .flatMap(validateStringNotEmpty)
              .flatMap(validateCharacters);
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.failure.runtimeType,
          isNot(EmptyFailure<String>().runtimeType));
    });
  });
}
