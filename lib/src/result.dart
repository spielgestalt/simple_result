import 'package:freezed_annotation/freezed_annotation.dart';
part 'result.freezed.dart';

@freezed
class Result<Success, Failure> with _$Result<Success, Failure> {
  const Result._();
  const factory Result.success(Success success) = _Success;
  const factory Result.failure(Failure failure) = _Failure;
  bool get isSuccess {
    return when(success: (_) => true, failure: (_) => false);
  }

  bool get isFailure {
    return when(success: (_) => false, failure: (_) => true);
  }

  Success? get success =>
      when(success: (success) => success, failure: (failure) => null);
  Failure? get failure =>
      when(success: (success) => null, failure: (failure) => failure);

  Result<ResultType, Failure?> flatMap<ResultType>(
    Result<ResultType, Failure> Function(Success?) mapper,
  ) {
    return when(
      success: (success) => mapper(success),
      failure: (failure) => Result.failure(failure),
    );
  }

  Success? getOrElse<ResultType>(Success Function() successFunction) {
    return when(
      success: (success) => success,
      failure: (failure) => successFunction(),
    );
  }

  Result<ResultType, Failure?> mapSuccess<ResultType>(
    ResultType Function(Success?) mapper,
  ) {
    return when(
      success: (success) =>
          Result<ResultType, Failure>.success(mapper(success)),
      failure: (failure) => Result<ResultType, Failure?>.failure(failure),
    );
  }

  @override
  String toString() {
    return when(
      success: (success) => success == null
          ? "Success: (null)"
          : 'Success: ${success.toString()}',
      failure: (failure) => failure == null
          ? 'Failure: (null)'
          : 'Failure: ${failure.toString()}',
    );
  }
}
