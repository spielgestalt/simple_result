# Simple Result for Dart

## Introduction

I needed a simple Result like Swift's [Result](https://developer.apple.com/documentation/swift/result).

I have seen people using [dartz](https://pub.dev/packages/dartz) with the Either type. But for me, thats not really clear and readable. 

Other solutions like [result](https://pub.dev/packages/result) and [super_enum](https://pub.dev/packages/super_enum) did not fit my needs neither. So here is my solution.

## Installation
Add the following to you `pubspec.yaml` and replace `[version]` with the latest version:

```dart
dependencies:
  simple_result: ^[version]

```
import with

```dart
import 'package:simple_result/simple_result.dart';
```

## Usage
To create a Result use 

```dart
SimpleResult<ValueType, FailureType>.success(value)
```
or 

```dart
SimpleResult<ValueType, FailureType>.failure(failure)
```

You can then 'iterate' over success or failure with:

```dart
result.when(
	success(value) {
		//doSomeThing with success value
	},
	failure(failure) {
		//doSomeThing with failure
	}
);
```

You can map the Result value type with map:

```dart
SimpleResult<User, Failure>.success(user);
final stringResult = result.map((user) => user.username);  
// stringResult is of Type Result<String, Failure>

```

You can use convenience methods on a Result

```dart
final userResult = SimpleResult<User, Failure>.success(user);
userResult.isSuccess; // -> true
userResult.success; // -> user object.
```

## Example
```dart
import 'package:simple_result/simple_result.dart';
final mySuccessResult = SimpleResult<String,Failure>.success('success value');
final myErrorResult = SimpleResult<String,Failure>.failure(MyFailure());

mySuccessResult.isSuccess // -> true
mySuccessResult.success; // -> 'success value'

final myStringResult = mySuccessResult
	.when(
		success:(value) => value.toString(), 
		failure:(_) => 'ERROR');
mySuccessResult.map((value) => 'StringResult'); // maps to Result<String, Failure>()

```

see more in [example/main.dart](https://github.com/spielgestalt/simple_result/blob/master/example/main.dart)