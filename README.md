# Simple Result for Dart

## Introduction

I needed a simple Result like Swift's [Result](https://developer.apple.com/documentation/swift/result).

I have seen people using [dartz](https://pub.dev/packages/dartz) with the Either type. But for me, thats not really clear and readable. 

Other solutions like [result](https://pub.dev/packages/result) and [super_enum](https://pub.dev/packages/super_enum) did not fit my needs neither. So here is my suggestion.

## Installation
Add the following to you `pubspec.yaml` and replace `[version]` with the latest version:

```dart
dependencies:
  simple_result: ^[version]

```
## Example
```import 'package:simple_result/simple_result.dart';

abstract class Failure {}

class SomeFailure extends Failure {}

void main() async {
	final result = await fetchUser();
	final resultAsString = result.when(
		success:(user) => user.username, 
		failure:(failre) => failire.toString());
	print(resultAsString);
}
Future<Result<Failure, User>>fetchUser() async {
	if (ok){
		return Result.success(user);
	}
	return Result.failure(SomeFailure());
} 
```

see more in [example/main.dart](https://github.com/spielgestalt/simple_result/blob/master/example/main.dart)