import 'package:result_handler/result_handler.dart';

/// This is the main function of the program.
void main() async {
  // Fetch data using the fetchData function, which returns a Result.
  final result = await fetchData();

  // Use the 'when' method to handle both Success and Failure cases.
  result.when(
    success: (value) => print('Success: $value'), // Prints success value.
    failure: (error) => print('Error: $error'), // Prints failure error.
  );

  // Transform the successful value using the 'map' method.
  final mappedResult = result.map((value) => value * 2);

  // Handle the mapped result, which can be a new Success or the same Failure.
  mappedResult.when(
    success: (value) => print(
        'Success mapped: $value'), // Prints the transformed success value.
    failure: (error) => print(
        'Error mapped: $error'), // Prints the failure error from original result.
  );

  // Transform the failure error using the 'mapFailure' method.
  final errorMappedResult = result.mapFailure((error) => 'New Error: $error');

  // Handle the result from mapFailure.
  errorMappedResult.when(
    success: (value) => print(
        'Success error mapped: $value'), // Prints the value from the original success result.
    failure: (error) => print(
        'Error error mapped: $error'), // Prints the transformed failure error.
  );

  // Chain a new successful Result with the successful value from result using the flatMap method.
  final flatMappedResult = result.flatMap((value) => Success(value * 3));

  // Handle the result from flatMap, which can be either a success from the transform or a failure if the original result was a failure.
  flatMappedResult.when(
    success: (value) => print(
        'Success flat mapped: $value'), // Prints the transformed success value.
    failure: (error) => print(
        'Error flat mapped: $error'), // Prints the failure error from the original result.
  );

  // Get value from the result with a default value in case it's a Failure.
  final finalValue = result.getOrElse((error) => -1);
  print(
      "final value: $finalValue"); // Prints result value or the default value.

  // Get the value or throw an exception if its a failure.
  try {
    final value = result.getOrThrow();
    print('Got: $value'); // Prints the result value if Success.
  } catch (e) {
    print(
        "Exception thrown : $e"); // Prints the exception if the result was a failure.
  }

  // Fetch data using the fetchData function again
  final resultB = await fetchData();
  // Chain a new successful Result using the bind method.
  final bindResult = resultB.bind((data) => Success(data * 50));
  bindResult.when(
    success: (value) => print(
        'Success bind: $value'), // Prints the result of the chained function
    failure: (error) => print(
        'Error bind: $error'), // Prints the failure error from original result.
  );
}

/// Simulates fetching data, returning a Result that can be either Success or Failure.
///
/// If the current second of the time is even, return a Success with the value 42.
/// Otherwise, return a Failure with a message.
Future<Result<String, int>> fetchData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate work
  if (DateTime.now().second % 2 == 0) {
    return Success(42); // Success case
  } else {
    return Failure("Data fetch failed"); // Failure case
  }
}
