import 'result.dart';

/// Extension methods for the [Result] type, providing a more functional API.
///
/// These methods are inspired by functional programming languages like Gleam
/// and Rust's `Result` type, offering a convenient way to work with
/// success/failure outcomes.
///
/// To use these extensions, import them explicitly:
/// `import 'package:flutter_package_result/result_extensions.dart';`
extension ResultExtensions<O, E> on Result<O, E> {
  /// Returns `true` if the result is [Ok].
  bool get isOk => this is Ok<O, E>;

  /// Returns `true` if the result is [Error].
  bool get isError => this is Error<O, E>;

  /// Maps an [Ok] value to a new [Result] with a different success type.
  ///
  /// If the result is [Ok], applies the [op] function to the contained value
  /// and returns a new [Ok] containing the result of the function.
  /// If the result is [Error], the original [Error] is propagated.
  Result<O2, E> map<O2>(O2 Function(O) op) {
    if (this is Ok<O, E>) {
      return Ok(op((this as Ok<O, E>).value));
    } else {
      return Error((this as Error<O, E>).error);
    }
  }

  /// Maps an [Error] value to a new [Result] with a different error type.
  ///
  /// If the result is [Error], applies the [op] function to the contained error
  /// and returns a new [Error] containing the result of the function.
  /// If the result is [Ok], the original [Ok] is propagated.
  Result<O, E2> mapError<E2>(E2 Function(E) op) {
    if (this is Error<O, E>) {
      return Error(op((this as Error<O, E>).error));
    } else {
      return Ok((this as Ok<O, E>).value);
    }
  }

  /// Chains a [Result]-returning function to the current [Result].
  ///
  /// If the result is [Ok], applies the [op] function to the contained value
  /// and returns the new [Result].
  /// If the result is [Error], the original [Error] is propagated.
  Result<O2, E> andThen<O2>(Result<O2, E> Function(O) op) {
    if (this is Ok<O, E>) {
      return op((this as Ok<O, E>).value);
    } else {
      return Error((this as Error<O, E>).error);
    }
  }

  /// Alias for [andThen], chains a [Result]-returning function to the current [Result].
  ///
  /// If the result is [Ok], applies the [op] function to the contained value
  /// and returns the new [Result].
  /// If the result is [Error], the original [Error] is propagated.
  Result<O2, E> flatMap<O2>(Result<O2, E> Function(O) op) => andThen(op);

  /// Chains a [Result]-returning function to the current [Result] for the error case.
  ///
  /// If the result is [Error], applies the [op] function to the contained error
  /// and returns the new [Result].
  /// If the result is [Ok], the original [Ok] is propagated.
  Result<O, E2> orElse<E2>(Result<O, E2> Function(E) op) {
    if (this is Error<O, E>) {
      return op((this as Error<O, E>).error);
    } else {
      return Ok((this as Ok<O, E>).value);
    }
  }

  /// Unwraps the [Ok] value.
  ///
  /// Returns the contained [Ok] value. Throws an [Exception] if the result is [Error].
  O unwrap() {
    if (this is Ok<O, E>) {
      return (this as Ok<O, E>).value;
    } else {
      throw Exception(
        'Called `unwrap()` on an `Error` value: ${(this as Error<O, E>).error}',
      );
    }
  }

  /// Unwraps the [Error] value.
  ///
  /// Returns the contained [Error] value. Throws an [Exception] if the result is [Ok].
  E unwrapError() {
    if (this is Error<O, E>) {
      return (this as Error<O, E>).error;
    } else {
      throw Exception(
        'Called `unwrapError()` on an `Ok` value: ${(this as Ok<O, E>).value}',
      );
    }
  }

  /// Folds the [Result] into a single value by applying one of two functions.
  ///
  /// If the result is [Ok], applies [okOp] to the contained value.
  /// If the result is [Error], applies [errorOp] to the contained error.
  T2 fold<T2>(T2 Function(O) okOp, T2 Function(E) errorOp) {
    if (this is Ok<O, E>) {
      return okOp((this as Ok<O, E>).value);
    } else {
      return errorOp((this as Error<O, E>).error);
    }
  }

  /// Performs a side effect if the result is [Ok].
  ///
  /// Applies the [op] function to the contained value without transforming it.
  /// Returns the original [Result].
  Result<O, E> tap(void Function(O) op) {
    if (this is Ok<O, E>) {
      op((this as Ok<O, E>).value);
    }
    return this;
  }

  /// Performs a side effect if the result is [Error].
  ///
  /// Applies the [op] function to the contained error without transforming it.
  /// Returns the original [Result].
  Result<O, E> tapError(void Function(E) op) {
    if (this is Error<O, E>) {
      op((this as Error<O, E>).error);
    }
    return this;
  }

  /// Performs a side effect if the result is [Ok].
  ///
  /// Applies the [op] function to the contained value.
  /// Returns the original [Result].
  Result<O, E> onOk(void Function(O) op) {
    if (this is Ok<O, E>) {
      op((this as Ok<O, E>).value);
    }
    return this;
  }

  /// Performs a side effect if the result is [Error].
  ///
  /// Applies the [op] function to the contained error.
  /// Returns the original [Result].
  Result<O, E> onError(void Function(E) op) {
    if (this is Error<O, E>) {
      op((this as Error<O, E>).error);
    }
    return this;
  }

  /// Returns the contained [Ok] value or computes a default from the [Error] value.
  ///
  /// If the result is [Ok], returns the contained value.
  /// If the result is [Error], applies the [orElse] function to the contained error
  /// and returns the result of that function.
  O getOrElse(O Function(E) orElse) {
    if (this is Ok<O, E>) {
      return (this as Ok<O, E>).value;
    } else {
      return orElse((this as Error<O, E>).error);
    }
  }

  /// Returns the contained [Ok] value if present, otherwise `null`.
  O? getOrNull() {
    if (this is Ok<O, E>) {
      return (this as Ok<O, E>).value;
    }
    return null;
  }

  /// Returns the contained [Error] value if present, otherwise `null`.
  E? errorOrNull() {
    if (this is Error<O, E>) {
      return (this as Error<O, E>).error;
    }
    return null;
  }

  /// Swaps the [Ok] and [Error] types.
  ///
  /// An [Ok<O, E>] becomes [Error<E, O>].
  /// An [Error<O, E>] becomes [Ok<E, O>].
  Result<E, O> swap() {
    if (this is Ok<O, E>) {
      return Error((this as Ok<O, E>).value as O);
    } else {
      return Ok((this as Error<O, E>).error as E);
    }
  }
}

extension ResultFlattenExtension<O2, E> on Result<Result<O2, E>, E> {
  /// Flattens a nested [Result].
  ///
  /// If the current [Result] is [Ok] and contains another [Result],
  /// it returns the inner [Result]. Otherwise, it returns the current [Result].
  Result<O2, E> flatten() {
    if (this is Ok<Result<O2, E>, E>) {
      return (this as Ok<Result<O2, E>, E>).value;
    } else {
      // If it's an Error, the outer error is propagated.
      return Error((this as Error<Result<O2, E>, E>).error);
    }
  }
}