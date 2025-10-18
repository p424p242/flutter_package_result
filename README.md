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

## 📚 Comprehensive Extension Methods Guide

### 🔍 Inspection Methods

#### `isOk` / `isError`
- **Purpose**: Check the variant of the result without unwrapping
- **When to use**: For simple boolean checks about the result state
- **Returns**: `bool`

```dart
final result = divide(10, 2);
if (result.isOk) {
  print('Operation succeeded');
}
if (result.isError) {
  print('Operation failed');
}
```

### 🔄 Transformation Methods

#### `map<O2>(O2 Function(O) op)`
- **Purpose**: Transform the success value to a new type
- **When to use**: When you need to convert the success value to a different type
- **Returns**: `Result<O2, E>`

```dart
final result = divide(10, 2);
final stringResult = result.map((value) => 'Result: $value');
// If original was Ok(5), becomes Ok('Result: 5')
// If original was Error, remains Error
```

#### `mapError<E2>(E2 Function(E) op)`
- **Purpose**: Transform the error value to a new type
- **When to use**: When you need to convert error types or add context to errors
- **Returns**: `Result<O, E2>`

```dart
final result = divide(10, 0);
final betterError = result.mapError((error) => 'Math error: $error');
// If original was Error('Division by zero'), becomes Error('Math error: Division by zero')
// If original was Ok, remains Ok
```

### ⛓️ Chaining Methods

#### `andThen<O2>(Result<O2, E> Function(O) op)` / `flatMap<O2>(Result<O2, E> Function(O) op)`
- **Purpose**: Chain operations that return another `Result`
- **When to use**: For sequential operations where each step can fail
- **Returns**: `Result<O2, E>`

```dart
Result<int, String> parseAndDivide(String input) {
  return parseNumber(input)
      .andThen((number) => divide(number, 2));
}
// If parseNumber returns Error, the chain stops
// If both succeed, returns the final result
```

#### `orElse<E2>(Result<O, E2> Function(E) op)`
- **Purpose**: Recover from errors by providing an alternative `Result`
- **When to use**: For fallback strategies and error recovery
- **Returns**: `Result<O, E2>`

```dart
final result = fetchFromPrimary()
    .orElse((error) => fetchFromSecondary());
// If primary fails, tries secondary
// If primary succeeds, returns primary result
```

### 🎯 Value Extraction Methods

#### `getOrElse(O Function(E) orElse)`
- **Purpose**: Extract the success value with a fallback for errors
- **When to use**: When you need a default value on error
- **Returns**: `O`

```dart
final result = divide(10, 0);
final value = result.getOrElse((error) => 0);
// Returns 0 if result was Error
// Returns the actual value if result was Ok
```

#### `getOrNull()`
- **Purpose**: Extract the success value as nullable
- **When to use**: When you want to handle missing values with null
- **Returns**: `O?`

```dart
final result = divide(10, 0);
final value = result.getOrNull();
// Returns null if result was Error
// Returns the actual value if result was Ok
```

#### `errorOrNull()`
- **Purpose**: Extract the error value as nullable
- **When to use**: When you want to check for errors without pattern matching
- **Returns**: `E?`

```dart
final result = divide(10, 2);
final error = result.errorOrNull();
// Returns null if result was Ok
// Returns the actual error if result was Error
```

### ⚠️ Unsafe Extraction Methods

#### `unwrap()`
- **Purpose**: Extract the success value, throwing on error
- **When to use**: Only when you're absolutely certain the result is `Ok`
- **Returns**: `O`
- **Throws**: `Exception` if result is `Error`

```dart
final result = divide(10, 2);
final value = result.unwrap(); // Safe here, returns 5

final badResult = divide(10, 0);
final badValue = result.unwrap(); // Throws Exception
```

#### `unwrapError()`
- **Purpose**: Extract the error value, throwing on success
- **When to use**: Only when you're absolutely certain the result is `Error`
- **Returns**: `E`
- **Throws**: `Exception` if result is `Ok`

```dart
final result = divide(10, 0);
final error = result.unwrapError(); // Safe here, returns 'Division by zero'

final goodResult = divide(10, 2);
final badError = result.unwrapError(); // Throws Exception
```

### 🎭 Side Effect Methods

#### `tap(void Function(O) op)` / `onOk(void Function(O) op)`
- **Purpose**: Perform side effects on success values
- **When to use**: For logging, analytics, or other side effects
- **Returns**: `Result<O, E>` (unchanged)

```dart
final result = divide(10, 2);
result.tap((value) => print('Got value: $value'));
// Prints 'Got value: 5' and returns original result
```

#### `tapError(void Function(E) op)` / `onError(void Function(E) op)`
- **Purpose**: Perform side effects on error values
- **When to use**: For error logging, error reporting, or other side effects
- **Returns**: `Result<O, E>` (unchanged)

```dart
final result = divide(10, 0);
result.tapError((error) => print('Got error: $error'));
// Prints 'Got error: Division by zero' and returns original result
```

### 🔄 Utility Methods

#### `fold<T2>(T2 Function(O) okOp, T2 Function(E) errorOp)`
- **Purpose**: Collapse the result into a single value
- **When to use**: When you need to convert both variants to a common type
- **Returns**: `T2`

```dart
final result = divide(10, 2);
final description = result.fold(
  (value) => 'Success: $value',
  (error) => 'Error: $error',
);
// Returns 'Success: 5' for Ok, 'Error: Division by zero' for Error
```

#### `swap()`
- **Purpose**: Swap the success and error types
- **When to use**: When you need to invert the meaning of success/error
- **Returns**: `Result<E, O>`

```dart
final result = divide(10, 2);
final swapped = result.swap();
// Ok(5) becomes Error(5)
// Error('Division by zero') becomes Ok('Division by zero')
```

#### `flatten()` (on `Result<Result<O2, E>, E>`)
- **Purpose**: Flatten nested results
- **When to use**: When you have operations that return nested results
- **Returns**: `Result<O2, E>`

```dart
Result<Result<int, String>, String> nested = Ok(Ok(42));
Result<int, String> flat = nested.flatten();
// Ok(Ok(42)) becomes Ok(42)
// Ok(Error('fail')) becomes Error('fail')
// Error('outer') becomes Error('outer')
```

### 🎯 Usage Patterns

#### Success-First Pipeline
```dart
AsyncResult<String, String> processUser(int userId) async {
  return await fetchUser(userId)
    .andThen(validateUser)
    .andThen(saveUser)
    .map((savedUser) => 'User processed: ${savedUser.name}')
    .mapError((error) => 'Processing failed: $error');
}
```

#### Error Recovery Pipeline
```dart
AsyncResult<String, String> fetchWithFallback(String url) async {
  return await fetchFromPrimary(url)
    .orElse((error) => fetchFromSecondary(url))
    .orElse((error) => fetchFromCache(url))
    .getOrElse((error) => 'Default content');
}
```

#### Conditional Processing
```dart
Result<String, String> processInput(String input) {
  return Ok(input)
    .andThen((value) =>
      value.isNotEmpty ? Ok(value) : Error('Input cannot be empty'))
    .map((nonEmpty) => nonEmpty.trim())
    .andThen((trimmed) =>
      trimmed.length >= 3 ? Ok(trimmed) : Error('Input too short'));
}
```

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