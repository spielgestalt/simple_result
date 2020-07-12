import 'package:test/test.dart';

import '../lib/simple_result.dart';

class MyFailure implements Exception{
  @override
  String toString() => 'MyFailure';
}
void main() {
  test('toString for a success object', () {
    const valueString = 'A String';
    final simpleStringResult = SimpleResult.success(valueString);
    expect(simpleStringResult.toString(),'Success: $valueString' );
  });
  test('toString for a success null object', () {    
    final simpleStringResult = SimpleResult.success(null);
    expect(simpleStringResult.toString(),'Success: (null)' );
  });

  test('toString for a failure object', () {
    const valueString = 'A String';
    final simpleStringResult = SimpleResult.failure(MyFailure());
    expect(simpleStringResult.toString(),'Failure: MyFailure' );
  });
  test('toString for a failure null object', () {    
    final simpleStringResult = SimpleResult.failure(null);
    expect(simpleStringResult.toString(),'Failure: (null)' );
  });
}