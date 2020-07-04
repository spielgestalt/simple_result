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

Result<String, ValueFailure<String>> validateCharacters(String input) {
  if (input.contains("-")) {
    return Result.failure(WrongCharacter());
  } else {
    return Result.success(input);
  }
}

Result<String, ValueFailure<String>> validateStringNotEmpty(String input) {
  if (input.isEmpty) {
    return Result.failure(EmptyFailure());
  } else {
    return Result.success(input);
  }
}

void main() {
  final correctString = "12345";
  final wrongCharacterString = "123-456";
  final emptyString = "";
  final maxLength = 10;
  final tooLongString = "12345678901";
  final wrongCharacterAndTooLong = "12345-67890";

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
