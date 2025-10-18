/// Alias for asynchronous operations that return a [Result].
///
/// This typedef simplifies the declaration of functions that might
/// succeed with a value of type [T] or fail with an error of type [E].
///
/// Example:
/// ```dart
/// AsyncResult<int, String> fetch() async => Ok(42);
/// ```
typedef AsyncResult<T, E> = Future<Result<T, E>>;

/// A sealed class representing either a successful outcome ([Ok])
/// or a failure with an error ([Error]).
///
/// This type is inspired by functional programming concepts for explicit
/// error handling, promoting type safety and reducing the need for exceptions.
///
/// 💡 Tip: While `switch` statements can be used for pattern matching,
/// consider using the extension methods (e.g., `map`, `mapError`, `fold`, `tap`)
/// provided in `package:result/result_extensions.dart` for a more
/// functional and chainable approach to handling [Result] instances.
sealed class Result<O, E> {}

/// Represents a successful outcome containing a [value] of type [O].
class Ok<O, E> extends Result<O, E> {
  /// Creates a successful [Result] with the given [value].
  Ok(this.value);

  /// The successful value.
  final O value;
}

/// Represents a failed outcome containing an [error] of type [E].
class Error<O, E> extends Result<O, E> {
  /// Creates a failed [Result] with the given [error].
  Error(this.error);

  /// The error value.
  final E error;
}