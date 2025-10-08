/// Alias for async results returning [Result].
///
/// Example:
/// ```dart
/// AsyncResult<int, String> fetch() async => Ok(42);
/// ```
typedef AsyncResult<T, E> = Future<Result<T, E>>;

/// Sealed result type: success ([Ok]) or failure ([Error]).
///
/// 💡 Tip: Use switch for pattern matching.
///
/// Example:
/// ```dart
/// switch (result) {
///   case Ok(:final value): print(value);
///   case Error(:final error): print(error);
/// }
/// ```
sealed class Result<O, E> {}

/// Success result with value.
class Ok<O, E> extends Result<O, E> {
  /// Creates success with [value].
  Ok(this.value);

  /// The success value.
  final O value;
}

/// Failure result with error.
class Error<O, E> extends Result<O, E> {
  /// Creates failure with [error].
  Error(this.error);

  /// The error value.
  final E error;
}
