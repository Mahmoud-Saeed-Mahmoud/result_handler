# Dart Result Handling Library

A simple and powerful library for handling results (successes and failures) in Dart, inspired by `Either` from functional programming libraries like `dartz`. This library uses `Success` and `Failure` classes to represent outcomes.

## Features

-   **Explicit Success/Failure:** Clearly distinguish between successful operations and those that resulted in an error.
-   **Type Safety:** Leverages Dart's type system to enforce correct handling of both successful and failed results.
-   **Functional Operations:** Provides methods like `map`, `mapFailure`, `flatMap`, `bind` and `when` for chaining and transforming results in a concise and readable way.
-   **Error Handling:** Provides methods `getOrElse` and `getOrThrow` for gracefully handle errors
-   **Simple API:** Easy to learn and integrate into your projects.

## Usage

Here's how to use the library:

```dart
import 'package:result_handler/result_handler.dart';

Future<Result<int, String>> fetchData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
  if (DateTime.now().second % 2 == 0) {
    return Success(42); // Success case
  } else {
    return Failure("Data fetch failed"); // Failure case
  }
}

void main() async {
  final result = await fetchData();

  result.when(
    success: (value) => print('Success: $value'),
    failure: (error) => print('Error: $error'),
  );

  final mappedResult = result.map((value) => value * 2);

   mappedResult.when(
    success: (value) => print('Success mapped: $value'),
    failure: (error) => print('Error mapped: $error'),
  );

   final errorMappedResult = result.mapFailure((error) => 'New Error: $error');

    errorMappedResult.when(
    success: (value) => print('Success error mapped: $value'),
    failure: (error) => print('Error error mapped: $error'),
  );
  
    final flatMappedResult = result.flatMap((value) => Success(value * 3));
    
     flatMappedResult.when(
        success: (value) => print('Success flat mapped: $value'),
        failure: (error) => print('Error flat mapped: $error'),
    );

  final finalValue = result.getOrElse((error) => -1);
    print("final value: $finalValue");


  try {
     final value = result.getOrThrow();
     print('Got: $value');
  } catch(e) {
    print("Exception thrown : $e");
  }
    final resultB = await fetchData();
  final bindResult = resultB.bind((data) => Success(data * 50));
  bindResult.when(
    success: (value) => print('Success bind: $value'),
    failure: (error) => print('Error bind: $error'),
  );
}
```

## API

### `Result<T, E>` (Abstract Class)

Represents the result of an operation, which can be either a `Success<T, E>` or a `Failure<T, E>`.

-   `bind<R>(Result<R, E> Function(T value) transform)`:  Binds a function to the `Result`.
-   `flatMap<R>(Result<R, E> Function(T value) transform)`: Similar to map but the transformation returns another Result.
-   `getOrElse(T Function(E error) orElse)`: Returns the value if it's a `Success`, otherwise returns the result of the orElse callback.
-   `getOrThrow()`: Returns the value if it's a `Success`, otherwise throws the error.
-   `map<R>(R Function(T value) transform)`: Transforms the value inside a `Success`, otherwise does nothing.
-   `mapFailure<R>(R Function(E error) transform)`: Transforms the error inside a `Failure`, otherwise does nothing.
-   `when<R>({required R Function(T data) success, required R Function(E error) failure})`: Executes the `success` callback if it's a `Success` or `failure` if it's a `Failure`.

### `Success<T, E>` (Class)

Represents a successful result, holding a value of type `T`.

### `Failure<T, E>` (Class)

Represents a failed result, holding an error of type `E`.

## License

This library is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Changelog

See the [CHANGELOG.md](CHANGELOG.md) file for a detailed history of changes.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

