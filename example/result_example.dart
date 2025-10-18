import 'package:flutter_package_result/result.dart';
import 'package:flutter_package_result/result_extensions.dart';

Result<int, String> divide(int a, int b) {
  if (b == 0) {
    return Error('Cannot divide by zero');
  } else {
    return Ok(a ~/ b);
  }
}

void main() {
  // --- isOk and isError ---
  final successResult = divide(10, 2);
  print('Success result is Ok: ${successResult.isOk}'); // true
  print('Success result is Error: ${successResult.isError}'); // false

  final errorResult = divide(10, 0);
  print('Error result is Ok: ${errorResult.isOk}'); // false
  print('Error result is Error: ${errorResult.isError}'); // true

  // --- map ---
  final mappedResult = successResult.map((value) => value * 2);
  print('Mapped success result: ${mappedResult.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Ok: 10

  final mappedErrorResult = errorResult.map((value) => value * 2);
  print('Mapped error result: ${mappedErrorResult.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Error: Cannot divide by zero

  // --- mapError ---
  final mappedErrorResult2 = errorResult.mapError((error) => 'Failed: $error');
  print('Mapped error result (error): ${mappedErrorResult2.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Error: Failed: Cannot divide by zero

  final mappedOkResult2 = successResult.mapError((error) => 'Failed: $error');
  print('Mapped ok result (error): ${mappedOkResult2.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Ok: 5

  // --- andThen ---
  final chainedResult = successResult.andThen((value) => divide(value, 1));
  print('Chained success result: ${chainedResult.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Ok: 5

  final chainedErrorResult = errorResult.andThen((value) => divide(value, 1));
  print('Chained error result: ${chainedErrorResult.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Error: Cannot divide by zero

  // --- orElse ---
  final orElseResult = errorResult.orElse((error) => Ok(0));
  print('OrElse error result: ${orElseResult.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Ok: 0

  final orElseOkResult = successResult.orElse((error) => Ok(0));
  print('OrElse ok result: ${orElseOkResult.fold((val) => 'Ok: $val', (err) => 'Error: $err')}'); // Ok: 5

  // --- unwrap ---
  try {
    print('Unwrap success: ${successResult.unwrap()}'); // 5
    // print('Unwrap error (will throw): ${errorResult.unwrap()}');
  } catch (e) {
    print('Caught unwrap error: $e'); // Caught unwrap error: Exception: Called `unwrap()` on an `Error` value: Cannot divide by zero
  }

  // --- unwrapError ---
  try {
    print('Unwrap error: ${errorResult.unwrapError()}'); // Cannot divide by zero
    // print('Unwrap success (will throw): ${successResult.unwrapError()}');
  } catch (e) {
    print('Caught unwrapError error: $e'); // Caught unwrapError error: Exception: Called `unwrapError()` on an `Ok` value: 5
  }

  // --- fold ---
  final foldedSuccess = successResult.fold(
    (value) => 'Success with value: $value',
    (error) => 'Failure with error: $error',
  );
  print('Folded success: $foldedSuccess'); // Success with value: 5

  final foldedError = errorResult.fold(
    (value) => 'Success with value: $value',
    (error) => 'Failure with error: $error',
  );
  print('Folded error: $foldedError'); // Failure with error: Cannot divide by zero
}
