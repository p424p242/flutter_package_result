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
  result: ^1.0.0
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

## Additional information

This package provides a functional programming approach to error handling in Dart and Flutter applications. It's inspired by Rust's `Result` type and provides a type-safe way to handle success and error cases.

- **Repository**: https://github.com/p424p424/flutter_pkg_result
- **Issues**: Please file issues on the GitHub repository
- **Contributions**: Pull requests are welcome!