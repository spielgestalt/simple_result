import 'package:meta/meta.dart';
/// A simple Result wrapper.
///
/// You can declare Success and Failure Types as Generic Type..
class Result<Success, Failure> {
  final bool _isSuccess;
  final Success _value;
  final Failure _failure;

  Result._({bool isSuccess, Success value, Failure failure})
      : _isSuccess = isSuccess,
        _value = value,
        _failure = failure;

  /// Marks this Result as successful.
  factory Result.success(Success value) {
    return Result._(isSuccess: true, value: value, failure: null);
  }

  /// Marks this Result as failing
  factory Result.failure(Failure failure) {
    return Result._(isSuccess: false, value: null, failure: failure);
  }

  /// Somehow like a switch case statement. You can return a Value from the
  /// functions success and failure.
  R when<R>(
      {@required R Function(Success) success,
      @required R Function(Failure) failure}) {
    if (_isSuccess) {
      return success(_value);
    }
    return failure(_failure);
  }
}
