# Result Package - Usage Guide

This package provides a functional programming Result type for Dart and Flutter applications, inspired by Rust's `Result` type and functional programming principles.

## 🚀 Quick Start

```dart
import 'package:result/result.dart';

Result<int, String> divide(int a, int b) {
  if (b == 0) return Error('Division by zero');
  return Ok(a ~/ b);
}

void main() {
  final result = divide(10, 2);

  // ✅ PREFERRED: Use extension methods
  result.onOk((value) => print('Result: $value'));
  result.onError((error) => print('Error: $error'));
}
```

## ❌ Avoid Pattern Matching - Use Extension Methods Instead

**Never use Dart pattern matching syntax (`switch` statements) when using this package.** The extension methods provide a much more concise, readable, and maintainable API.

### Pattern Matching (❌ NOT RECOMMENDED)

```dart
// ❌ Verbose and error-prone
String describeResult(Result<int, String> result) {
  switch (result) {
    case Ok(:final value):
      return 'Success: $value';
    case Error(:final error):
      return 'Error: $error';
  }
}
```

### Extension Methods (✅ RECOMMENDED)

```dart
// ✅ Clean and expressive
String describeResult(Result<int, String> result) {
  return result.fold(
    (value) => 'Success: $value',
    (error) => 'Error: $error',
  );
}
```

## 🔧 Core Extension Methods

### Transformation Methods

```dart
final result = divide(10, 2);

// Transform success values
final doubled = result.map((value) => value * 2);

// Transform error values
final betterError = result.mapError((error) => 'Failed: $error');

// Chain operations (monadic bind)
final chained = result.andThen((value) => divide(value, 1));

// Recover from errors
final recovered = result.orElse((error) => Ok(0));
```

### Side Effect Methods

```dart
// Perform side effects on success
result.tap((value) => print('Got value: $value'));

// Perform side effects on errors
result.tapError((error) => print('Got error: $error'));

// Aliases for the same functionality
result.onOk((value) => print('Got value: $value'));
result.onError((error) => print('Got error: $error'));
```

### Extraction Methods

```dart
// Extract values safely
final value = result.getOrElse((error) => 0);
final nullableValue = result.getOrNull();
final nullableError = result.errorOrNull();

// Unsafe extraction (throws on wrong variant)
try {
  final value = result.unwrap();
} catch (e) {
  print('Result was an error');
}

try {
  final error = result.unwrapError();
} catch (e) {
  print('Result was a success');
}
```

### Utility Methods

```dart
// Collapse to single value
final description = result.fold(
  (value) => 'Success: $value',
  (error) => 'Error: $error',
);

// Swap success and error types
final swapped = result.swap();

// Flatten nested results
final nested = Ok(Ok(42));
final flattened = nested.flatten();
```

## 🔄 Async Results

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

  // All extension methods work the same way
  result
    .map((data) => data * 2)
    .onOk((doubled) => print('Doubled: $doubled'))
    .onError((error) => print('Failed: $error'));
}
```

## 🎯 Functional Chaining Patterns

### Success-First Pipeline

```dart
AsyncResult<String, String> processUser(int userId) async {
  return await fetchUser(userId)
    .andThen((user) => validateUser(user))
    .andThen((validUser) => saveUser(validUser))
    .map((savedUser) => 'User processed: ${savedUser.name}')
    .mapError((error) => 'Processing failed: $error');
}
```

### Error Recovery Pipeline

```dart
AsyncResult<String, String> fetchWithFallback(String url) async {
  return await fetchFromPrimary(url)
    .orElse((error) => fetchFromSecondary(url))
    .orElse((error) => fetchFromCache(url))
    .getOrElse((error) => 'Default content');
}
```

### Conditional Processing

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

## 📚 Best Practices

### 1. Always Use Extension Methods

- **✅ DO**: Use `map`, `andThen`, `fold`, `tap`, etc.
- **❌ DON'T**: Use `switch` statements or pattern matching

### 2. Chain Operations

```dart
// ✅ Good: Chain operations
final result = fetchData()
  .map(processData)
  .andThen(saveData)
  .onOk(logSuccess)
  .onError(handleError);

// ❌ Bad: Manual pattern matching
final result = fetchData();
switch (result) {
  case Ok(:final value):
    final processed = processData(value);
    final saved = saveData(processed);
    logSuccess(saved);
  case Error(:final error):
    handleError(error);
}
```

### 3. Use `fold` for Final Extraction

```dart
// ✅ Good: Use fold for final value extraction
final output = result.fold(
  (value) => 'Success: $value',
  (error) => 'Error: $error',
);

// ❌ Bad: Manual extraction with pattern matching
final output = switch (result) {
  Ok(:final value) => 'Success: $value',
  Error(:final error) => 'Error: $error',
};
```

### 4. Prefer `getOrElse` Over `unwrap`

```dart
// ✅ Good: Safe extraction with fallback
final value = result.getOrElse((error) => defaultValue);

// ❌ Bad: Unsafe extraction that can throw
final value = result.unwrap();
```

## 🎨 Real-World Examples

### API Client

```dart
class ApiClient {
  AsyncResult<User, String> fetchUser(int id) async {
    return await http.get(Uri.parse('/users/$id'))
      .map((response) => response.body)
      .andThen((body) => parseUser(body))
      .mapError((error) => 'Failed to fetch user: $error');
  }

  AsyncResult<List<User>, String> fetchUsers() async {
    return await http.get(Uri.parse('/users'))
      .map((response) => response.body)
      .andThen((body) => parseUsers(body))
      .mapError((error) => 'Failed to fetch users: $error');
  }
}
```

### Form Validation

```dart
Result<User, List<String>> validateUserForm(String name, String email, int age) {
  return Ok((name: name, email: email, age: age))
    .andThen((data) => validateName(data.name))
    .andThen((data) => validateEmail(data.email))
    .andThen((data) => validateAge(data.age))
    .map((validData) => User(
      name: validData.name,
      email: validData.email,
      age: validData.age,
    ));
}

Result<ValidatedData, List<String>> validateName(String name) {
  final errors = <String>[];
  if (name.isEmpty) errors.add('Name is required');
  if (name.length < 2) errors.add('Name too short');

  return errors.isEmpty
    ? Ok(ValidatedData(name: name))
    : Error(errors);
}
```

## 🚫 Anti-Patterns to Avoid

### 1. Pattern Matching Everywhere

```dart
// ❌ Anti-pattern: Excessive pattern matching
void handleResult(Result<int, String> result) {
  switch (result) {
    case Ok(:final value):
      switch (value) {
        case > 0:
          print('Positive');
        case 0:
          print('Zero');
        case < 0:
          print('Negative');
      }
    case Error(:final error):
      print('Error: $error');
  }
}

// ✅ Better: Use extension methods
void handleResult(Result<int, String> result) {
  result
    .map((value) => value > 0 ? 'Positive' : value < 0 ? 'Negative' : 'Zero')
    .onOk((description) => print(description))
    .onError((error) => print('Error: $error'));
}
```

### 2. Manual Error Propagation

```dart
// ❌ Anti-pattern: Manual error checking
Result<int, String> processStep1() {
  final result1 = step1();
  if (result1.isError) return result1;

  final result2 = step2(result1.unwrap());
  if (result2.isError) return result2;

  return step3(result2.unwrap());
}

// ✅ Better: Use andThen for automatic propagation
Result<int, String> processStep1() {
  return step1()
    .andThen(step2)
    .andThen(step3);
}
```

## 📖 Summary

This Result package provides a powerful, type-safe way to handle success and error cases in your Dart and Flutter applications. **Always prefer the extension methods over Dart pattern matching** for cleaner, more maintainable code.

Key benefits:
- **Type safety**: Compile-time guarantees
- **Functional programming**: Rich set of combinators
- **Async support**: Built-in support for asynchronous operations
- **Zero dependencies**: Pure Dart implementation
- **Modern Dart**: Leverages Dart 3 features

Remember: **Extension methods > Pattern matching** for all Result operations!