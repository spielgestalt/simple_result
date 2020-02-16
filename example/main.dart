import 'package:meta/meta.dart';
import 'package:simple_result/simple_result.dart';

class User {
  final String username;

  User({@required this.username});
}

abstract class Failure {
  String get message;

  String toString() {
    return message;
  }
}

class SomeFailure extends Failure {
  final message = 'Some Failure happened';
}

void main() async {
  final okResult = await fetchFromServer(false);
  final username = okResult.when(
      success: (user) => user.username,
      failure: (failure) => "ERROR:${failure}");
  print(username); //bob

  final errorResult = await fetchFromServer(true);
  final usernameNotOk = errorResult.when(
      success: (user) => user.username,
      failure: (failure) => "ERROR:${failure}");
  print(usernameNotOk); // ERROR:Some Failure happened
}

Future<Result<User, Failure>> fetchFromServer(bool withError) async {
  await Future.delayed(Duration(milliseconds: 100));
  if (withError) {
    return Result.failure(SomeFailure());
  } else {
    return Result.success(User(username: 'bob'));
  }
}
