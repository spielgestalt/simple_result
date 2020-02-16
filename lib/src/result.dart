import 'package:meta/meta.dart';

class Result<Failure, Success> {
  final bool _isSuccess;
  final Success _value;
  final Failure _failure;

  Result._({bool isSuccess, Success value, Failure failure})
      : _isSuccess = isSuccess,
        _value = value,
        _failure = failure;

  factory Result.success(Success value) {
    return Result._(isSuccess: true, value: value, failure: null);
  }

  factory Result.failure(Failure failure) {
    return Result._(isSuccess: false, value: null, failure: failure);
  }

  R when<R>(
      {@required R Function(Success) success,
      @required R Function(Failure) failure}) {
    if (_isSuccess) {
      return success(_value);
    }
    return failure(_failure);
  }
}
