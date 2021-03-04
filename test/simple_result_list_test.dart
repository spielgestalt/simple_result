import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

class User {
  final String name;

  User({required this.name});
}

class NameFailure implements Exception {}

SimpleResult<List<User>, NameFailure> getUsers({required bool doFail}) {
  if (doFail) {
    return SimpleResult.failure(NameFailure());
  }
  return SimpleResult.success([User(name: 'John'), User(name: 'Marry')]);
}

void main() {
  test('check list resolution', () {
    final result = getUsers(doFail: false);
    expect(result.isSuccess, isTrue);
    expect(result.success!.length, 2);
  });
}
