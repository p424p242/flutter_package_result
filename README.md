# Result

A functional programming Result type for Dart and Flutter with pattern matching support.

## Features

- **Sealed Result Type**: `Result<O, E>` with `Ok<O, E>` and `Error<O, E>` variants
- **Pattern Matching**: Use Dart's switch expressions for clean, safe pattern matching
- **Async Support**: `AsyncResult<T, E>` type alias for `Future<Result<T, E>>`
- **Type Safety**: Compile-time safety with exhaustive pattern matching

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  result: ^1.2.0
```

## Usage

### Basic Result Usage

```dart
import 'package:result/result.dart';

Result<int, String> divide(int a, int b) {
  if (b == 0) {
    return Error('Division by zero');
  }
  return Ok(a ~/ b);
}

void main() {
  final result = divide(10, 2);

  switch (result) {
    case Ok(:final value):
      print('Result: $value'); // Result: 5
    case Error(:final error):
      print('Error: $error');
  }
}
```

### Async Results

```dart
AsyncResult<int, String> fetchData() async {
  try {
    final data = await someApiCall();
    return Ok(data);
  } catch (e) {
    return Error(e.toString());
  }
}

void main() async {
  final result = await fetchData();

  switch (result) {
    case Ok(:final value):
      print('Data: $value');
    case Error(:final error):
      print('Failed: $error');
  }
}
```

### Pattern Matching with Switch Expressions

```dart
String describeResult(Result<int, String> result) => switch (result) {
  Ok(:final value) => 'Success: $value',
  Error(:final error) => 'Error: $error',
};
```

### Extension Methods for Functional Chaining

The `result` package provides a rich set of extension methods to enable a more functional and chainable approach to handling `Result` types, reducing the need for explicit `switch` statements. To use these, ensure you import `package:result/result.dart` (which now exports `result_extensions.dart`).

Here are some of the key extension methods:

-   **`map<O2>(O2 Function(O) op)`**: Transforms the `Ok` value to a new type.
-   **`mapError<E2>(E2 Function(E) op)`**: Transforms the `Error` value to a new type.
-   **`andThen<O2>(Result<O2, E> Function(O) op)` / `flatMap<O2>(Result<O2, E> Function(O) op)`**: Chains operations that return another `Result`.
-   **`orElse<E2>(Result<O, E2> Function(E) op)`**: Chains operations for the error case, potentially recovering from an error.
-   **`tap(void Function(O) op)` / `onOk(void Function(O) op)`**: Performs a side effect if the result is `Ok`, returning the original `Result`.
-   **`tapError(void Function(E) op)` / `onError(void Function(E) op)`**: Performs a side effect if the result is `Error`, returning the original `Result`.
-   **`getOrElse(O Function(E) orElse)`**: Returns the `Ok` value or a computed default from the `Error`.
-   **`getOrNull()`**: Returns the `Ok` value if present, otherwise `null`.
-   **`errorOrNull()`**: Returns the `Error` value if present, otherwise `null`.
-   **`unwrap()`**: Returns the `Ok` value or throws an exception if `Error`.
-   **`unwrapError()`**: Returns the `Error` value or throws an exception if `Ok`.
-   **`fold<T2>(T2 Function(O) okOp, T2 Function(E) errorOp)`**: Collapses the `Result` into a single value by applying one of two functions.
-   **`flatten()`**: (Available on `Result<Result<O2, E>, E>`) Flattens a nested `Result`.

**Example using extension methods:**

```dart
import 'package:result/result.dart';

AsyncResult<String, String> processData(int input) async {
  return Ok(input)
      .andThen((value) => value > 0 ? Ok('Positive: $value') : Error('Not positive'))
      .map((success) => 'Processed: $success')
      .mapError((error) => 'Failed to process: $error');
}

void main() async {
  final result1 = await processData(5);
  result1.onOk((data) => print('Success: $data')); // Success: Processed: Positive: 5
  result1.onError((error) => print('Error: $error'));

  final result2 = await processData(-1);
  result2.onOk((data) => print('Success: $data'));
  result2.onError((error) => print('Error: $error')); // Error: Failed to process: Not positive

  final value = result1.getOrElse((error) => 'Default Value');
  print('Value: $value'); // Value: Processed: Positive: 5
}
```

## Additional information

This package provides a functional programming approach to error handling in Dart and Flutter applications. It's inspired by Rust's `Result` type and provides a type-safe way to handle success and error cases.

- **Repository**: https://github.com/p424p424/flutter_pkg_result
- **Issues**: Please file issues on the GitHub repository
- **Contributions**: Pull requests are welcome!

### 📖 Comprehensive Usage Guide

For detailed usage instructions, best practices, and real-world examples, see the [CLAUDE.md](CLAUDE.md) guide.