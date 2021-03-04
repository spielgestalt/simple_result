import 'package:equatable/equatable.dart';

typedef FlatMapFunction<A, B> = int Function(double a);

/// A simple Result wrapper.
///
/// You can declare Success and Failure Types as Generic Type..
class SimpleResult<Success, Failure> extends Equatable {
  final bool _isSuccess;
  final Success? _value;
  final Failure? _failure;

  const SimpleResult._(
      {required bool isSuccess, Success? value, Failure? failure})
      : _isSuccess = isSuccess,
        _value = value,
        _failure = failure;

  /// Marks this Result as successful.
  factory SimpleResult.success(Success value) {
    return SimpleResult._(isSuccess: true, value: value);
  }

  /// Marks this Result as failing
  factory SimpleResult.failure(Failure failure) {
    return SimpleResult._(isSuccess: false, failure: failure);
  }

  /// returns true, if the result is in success state.
  bool get isSuccess => _isSuccess;

  /// returns true, if the result is in failure state.
  bool get isFailure => _isSuccess == false;

  /// returns the success value or null if there is a failure.
  Success? get success => _value;

  /// returns the failure or null if the state is success.
  Failure? get failure => _failure;

  /// Somehow like a switch case statement. You can return a Value from the
  /// functions success and failure.
  ResultType? when<ResultType>(
      {required ResultType Function(Success?)? success,
      required ResultType Function(Failure?)? failure}) {
    if (_isSuccess) {
      if (success == null) {
        return null;
      }
      return success(_value);
    }
    if (failure == null) {
      return null;
    }
    return failure(_failure);
  }

  Success? getOrElse<ResultType>(Success Function() successFunction) {
    if (_isSuccess) {
      return _value;
    }
    return successFunction();
  }

  /// Use map to convert a Result from one value type to another.
  /// Changes only value type, not the Failure.
  SimpleResult<ResultType, Failure?> map<ResultType>(
      ResultType Function(Success?) mapper) {
    if (_isSuccess) {
      return SimpleResult<ResultType, Failure>.success(mapper(_value));
    } else {
      return SimpleResult<ResultType, Failure?>.failure(_failure);
    }
  }

  // Either<L, R2> flatMap<R2>(Function1<R, Either<L, R2>> f) => fold(left, f);
  /*Result<ResultType, Failure> flatMap<ResultType>(
      Function1<ResultType, Failure> f) {
    if (_isSuccess) {}
  }*/
  SimpleResult<ResultType, Failure?> flatMap<ResultType>(
      SimpleResult<ResultType, Failure> Function(Success?) mapper) {
    if (_isSuccess) {
      final result = mapper(_value);
      return result;
    }
    return SimpleResult<ResultType, Failure?>.failure(_failure);
  }

  @override
  List<Object?> get props => [_value, _failure, _isSuccess];

  @override
  String toString() {
    if (_isSuccess) {
      return _value == null
          ? "Success: (null)"
          : 'Success: ${_value.toString()}';
    }
    return _failure == null
        ? 'Failure: (null)'
        : 'Failure: ${_failure.toString()}';
  }
}
