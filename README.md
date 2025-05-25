# Dart Result Handling Library

[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev) [![Pub Version](https://img.shields.io/pub/v/result_handler)](https://pub.dev/packages/result_handler) [![Pub Likes](https://img.shields.io/pub/likes/result_handler)](https://img.shields.io/pub/likes/result_handler) [![Pub Publisher](https://img.shields.io/pub/publisher/result_handler)](https://img.shields.io/pub/publisher/result_handler) ![Pub Points](https://img.shields.io/pub/points/result_handler) ![Pub Monthly Downloads](https://img.shields.io/pub/dm/result_handler) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

A simple and powerful library for handling results (successes and failures) in Dart, inspired by `Either` from functional programming libraries like `dartz`. This library uses `Success` and `Failure` classes to represent outcomes.

## Features

- **Explicit Success/Failure:** Clearly distinguish between successful operations and those that resulted in an error.
- **Type Safety:** Leverages Dart's type system to enforce correct handling of both successful and failed results.
- **Functional Operations:** Provides methods like `map`, `mapFailure`, `flatMap`, `bind` and `when` for chaining and transforming results in a concise and readable way.
- **Error Handling:** Provides methods `getOrElse` and `getOrThrow` for gracefully handle errors
- **Convenience Methods:** Type checking with `isSuccess`/`isFailure` getters and safe value access with `getOrNull`/`getErrorOrNull`
- **Side Effects:** Execute side-effect operations with `tap` and `tapError` methods
- **Error Recovery:** Recover from failures using `orElse` method
- **Filtering:** Filter success values with `filterOrElse` method
- **Collection Operations:** Work with multiple results using `sequence` static method
- **Factory Methods:** Create results safely with `tryCatch`, `tryCatchAsync`, and `fromNullable`
- **Combining Results:** Combine multiple results with `zipWith` method
- **Unit Type:** Use `Unit` type for operations that don't return meaningful values
- **Simple API:** Easy to learn and integrate into your projects.

## Usage

Here's how to use the library:

```dart
import 'package:result_handler/result_handler.dart';

// Using the new tryCatchAsync factory method
Future<Result<String, int>> fetchData() async {
  return Result.tryCatchAsync(
    () async {
      await Future.delayed(const Duration(seconds: 1)); // Simulate work
      if (DateTime.now().second % 2 == 0) {
        return 42; // Success case
      } else {
        throw Exception("Data fetch failed"); // This will be caught
      }
    },
    (error, stackTrace) => "Network error: ${error.toString()}",
  );
}

// Example of a validation function
Result<String, int> validateAge(int? age) {
  return Result.fromNullable(age, () => "Age cannot be null")
      .filterOrElse(
        (value) => value >= 0 && value <= 150,
        (value) => "Invalid age: $value",
      );
}

void main() async {
  final result = await fetchData();

  // Basic pattern matching
  result.when(
    success: (value) => print('Success: $value'),
    failure: (error) => print('Error: $error'),
  );

  // Using convenience getters
  if (result.isSuccess) {
    print('Operation succeeded with value: ${result.getOrNull()}');
  }

  // Chain operations with tap for side effects
  final processedResult = result
      .tap((value) => print('Processing value: $value')) // Side effect
      .map((value) => value * 2)
      .tapError((error) => print('Logging error: $error')); // Error side effect

  // Error recovery
  final recoveredResult = result.orElse((error) => Success(0));
  print('Recovered value: ${recoveredResult.getOrElse((_) => -1)}');

  // Working with multiple results
  final results = [Success<String, int>(1), Success<String, int>(2), Success<String, int>(3)];
  final sequenceResult = Result.sequence(results);
  sequenceResult.when(
    success: (values) => print('All values: $values'),
    failure: (error) => print('One failed: $error'),
  );

  // Combining results
  final result1 = Success<String, int>(10);
  final result2 = Success<String, int>(20);
  final combined = result1.zipWith(result2, (a, b) => a + b);
  print('Combined: ${combined.getOrElse((_) => 0)}');

  // Validation example
  final ageValidation = validateAge(25);
  ageValidation.when(
    success: (age) => print('Valid age: $age'),
    failure: (error) => print('Validation error: $error'),
  );

  // Using Unit for operations without meaningful return values
  final saveResult = Result.tryCatch<String, Unit>(
    () {
      // Simulate a save operation
      print('Saving data...');
      return const Unit();
    },
    (error, stackTrace) => 'Save failed: ${error.toString()}',
  );

  saveResult.when(
    success: (_) => print('Save completed successfully'),
    failure: (error) => print('Save failed: $error'),
  );
}
```

## API

### `Result<E, T>` (Abstract Class)

Represents the result of an operation, which can be either a `Success<E, T>` or a `Failure<E, T>`.

#### Core Methods

- `bind<R>(Result<E, R> Function(T value) transform)`: Binds a function to the `Result`.
- `flatMap<R>(Result<E, R> Function(T value) transform)`: Similar to map but the transformation returns another Result.
- `map<R>(R Function(T value) transform)`: Transforms the value inside a `Success`, otherwise does nothing.
- `mapFailure<R>(R Function(E error) transform)`: Transforms the error inside a `Failure`, otherwise does nothing.
- `when<R>({required R Function(T data) success, required R Function(E error) failure})`: Executes the `success` callback if it's a `Success` or `failure` if it's a `Failure`.

#### Value Access Methods

- `getOrElse(T Function(E error) orElse)`: Returns the value if it's a `Success`, otherwise returns the result of the orElse callback.
- `getOrThrow()`: Returns the value if it's a `Success`, otherwise throws the error.
- `getOrNull()`: Returns the value if it's a `Success`, otherwise returns `null`.
- `getErrorOrNull()`: Returns the error if it's a `Failure`, otherwise returns `null`.

#### Type Checking

- `isSuccess`: Returns `true` if this is a `Success`.
- `isFailure`: Returns `true` if this is a `Failure`.

#### Side Effects

- `tap(void Function(T value) fn)`: Executes a function with the success value for side effects.
- `tapError(void Function(E error) fn)`: Executes a function with the error value for side effects.

#### Error Recovery

- `orElse(Result<E, T> Function(E error) recoveryFn)`: Attempts to recover from a failure.

#### Filtering

- `filterOrElse(bool Function(T value) predicate, E Function(T value) errorIfFalse)`: Filters success values based on a predicate.

#### Combining Results

- `zipWith<U, R>(Result<E, U> other, R Function(T a, U b) combiner)`: Combines this result with another result.

#### Static Factory Methods

- `Result.fromNullable<E, T>(T? value, E Function() errorIfNull)`: Creates a Result from a nullable value.
- `Result.tryCatch<E, T>(T Function() fn, E Function(Object error, StackTrace stackTrace) onError)`: Safely executes a function and wraps the result.
- `Result.tryCatchAsync<E, T>(Future<T> Function() fn, E Function(Object error, StackTrace stackTrace) onError)`: Safely executes an async function and wraps the result.
- `Result.sequence<E, T>(Iterable<Result<E, T>> results)`: Transforms multiple results into a single result containing a list.

### `Success<E, T>` (Class)

Represents a successful result, holding a value of type `T`.

- `data`: The successful value of type `T`.
- Implements all `Result` methods with success-specific behavior.
- Supports equality comparison and proper `toString()` representation.

### `Failure<E, T>` (Class)

Represents a failed result, holding an error of type `E`.

- `error`: The error value of type `E`.
- Implements all `Result` methods with failure-specific behavior.
- Supports equality comparison and proper `toString()` representation.

### `Unit` (Class)

Represents a unit type for operations that complete successfully but don't return meaningful values.

- Useful for `Result<E, Unit>` when you only care about success/failure, not the return value.
- All `Unit` instances are considered equal.
- Commonly used for operations like save, delete, or update that don't return data.

## License

This library is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Changelog

See the [CHANGELOG.md](CHANGELOG.md) file for a detailed history of changes.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
