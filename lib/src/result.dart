import 'package:meta/meta.dart';

typedef int FlatMapFunction<A, B>(double a);

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

  /// returns true, if the result is in success state.
  bool get isSuccess => _isSuccess;

  /// returns true, if the result is in failure state.
  bool get isFailure => _isSuccess == false;

  /// returns the success value or null if there is a failure.
  Success get success => _value;

  /// returns the failure or null if the state is success.
  Failure get failure => _failure;

  /// Somehow like a switch case statement. You can return a Value from the
  /// functions success and failure.
  ResultType when<ResultType>(
      {@required ResultType Function(Success) success,
      @required ResultType Function(Failure) failure}) {
    if (_isSuccess) {
      return success(_value);
    }
    return failure(_failure);
  }

  /// Use map to convert a Result from one value type to another.
  /// Changes only value type, not the Failure.
  Result<ResultType, Failure> map<ResultType>(
      ResultType Function(Success) mapper) {
    if (_isSuccess) {
      return Result<ResultType, Failure>.success(mapper(_value));
    } else {
      return Result<ResultType, Failure>.failure(_failure);
    }
  }

  // Either<L, R2> flatMap<R2>(Function1<R, Either<L, R2>> f) => fold(left, f);
  /*Result<ResultType, Failure> flatMap<ResultType>(
      Function1<ResultType, Failure> f) {
    if (_isSuccess) {}
  }*/
  Result<ResultType, Failure> flatMap<ResultType>(
      Result<ResultType, Failure> Function(Success) mapper) {
    if (_isSuccess) {
      final result = mapper(_value);
      return result;
    }
    return Result<ResultType, Failure>.failure(_failure);
  }
}
