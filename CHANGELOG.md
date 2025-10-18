# Changelog

## 1.2.0

- **Improved type safety**: Replaced unsafe type casts with pattern matching in all extension methods
- **Removed unused dependency**: Removed `copy_with_extension_gen` from dev dependencies
- **Enhanced documentation**: Added comprehensive `CLAUDE.md` usage guide emphasizing extension methods over pattern matching
- **Performance improvements**: All extension methods now use Dart 3 pattern matching for better performance and type safety

## 1.1.0

- Added `ResultExtensions` with new extension methods:
  - `tap`: Performs a side effect if the result is `Ok`.
  - `tapError`: Performs a side effect if the result is `Error`.
  - `onOk`: Alias for `tap`.
  - `onError`: Alias for `tapError`.
  - `getOrElse`: Returns the `Ok` value or computes a default from the `Error` value.
  - `getOrNull`: Returns the `Ok` value if present, otherwise `null`.
  - `errorOrNull`: Returns the `Error` value if present, otherwise `null`.
  - `swap`: Swaps the `Ok` and `Error` types.
  - `flatMap`: Alias for `andThen`.
- Added `ResultFlattenExtension` with `flatten` method for nested `Result` types.
- Improved documentation for `Result` and `AsyncResult` to highlight extension methods.
- Exported `result_extensions.dart` from `result.dart` for easier access.

## 1.0.0

- Initial release
- Added `Result<O, E>` sealed class with `Ok<O, E>` and `Error<O, E>` variants
- Added `AsyncResult<T, E>` type alias for `Future<Result<T, E>>`
- Support for Dart pattern matching with switch expressions
- Comprehensive documentation and examples
