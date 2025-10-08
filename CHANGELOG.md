# Changelog

## 1.0.0

- Initial release
- Added `Result<O, E>` sealed class with `Ok<O, E>` and `Error<O, E>` variants
- Added `AsyncResult<T, E>` type alias for `Future<Result<T, E>>`
- Support for Dart pattern matching with switch expressions
- Comprehensive documentation and examples