import 'package:result_handler/result_handler.dart';

void main() {
  // Unit Type
  const successNoValue = Success<String, Unit>(Unit());
  print(successNoValue); // Output: Success(Unit())

  // isSuccess / isFailure
  final Result<String, int> successResult = Success(10);
  final Result<String, int> failureResult = Failure("Something went wrong");
  print('successResult.isSuccess: ${successResult.isSuccess}'); // true
  print('successResult.isFailure: ${successResult.isFailure}'); // false
  print('failureResult.isSuccess: ${failureResult.isSuccess}'); // false
  print('failureResult.isFailure: ${failureResult.isFailure}'); // true

  // getOrNull / getErrorOrNull
  print('successResult.getOrNull: ${successResult.getOrNull()}'); // 10
  print(
      'successResult.getErrorOrNull: ${successResult.getErrorOrNull()}'); // null
  print('failureResult.getOrNull: ${failureResult.getOrNull()}'); // null
  print(
      'failureResult.getErrorOrNull: ${failureResult.getErrorOrNull()}'); // Something went wrong

  // tap / tapError
  Success(100)
      .tap((value) =>
          print('Tapped success: $value')) // Prints: Tapped success: 100
      .tapError((err) => print('This should not print'));

  Failure<String, int>("Error 404")
      .tap((value) => print('This should not print'))
      .tapError((err) =>
          print('Tapped error: $err')); // Prints: Tapped error: Error 404

  // orElse
  Result<String, int> recovered =
      Failure<String, int>("Initial Error").orElse((error) {
    print('orElse recovery attempt for: $error');
    return Success(0); // Attempt to recover with a default value
  });
  print('Recovered result: ${recovered.getOrNull()}'); // 0

  Result<String, int> notRecovered = Success<String, int>(5).orElse((error) {
    print('This orElse should not be called');
    return Failure("Should not happen");
  });
  print('Not-recovered result: ${notRecovered.getOrNull()}'); // 5

  // filterOrElse
  Result<String, int> validResult = Success<String, int>(10).filterOrElse(
    (value) => value > 5,
    (value) => "Value $value is not greater than 5",
  );
  print('Valid filter: ${validResult.getOrNull()}'); // 10

  Result<String, int> invalidResult = Success<String, int>(3).filterOrElse(
    (value) => value > 5,
    (value) => "Value $value is not greater than 5",
  );
  print(
      'Invalid filter: ${invalidResult.getErrorOrNull()}'); // Value 3 is not greater than 5

  // Result.tryCatch
  Result<String, int> trySuccess = Result.tryCatch(
    () => int.parse("123"),
    (e, s) => "Parse error: $e",
  );
  print('tryCatch success: ${trySuccess.getOrNull()}'); // 123

  Result<String, int> tryFailure = Result.tryCatch(
    () => int.parse("abc"),
    (e, s) => "Parse error: $e",
  );
  print(
      'tryCatch failure: ${tryFailure.getErrorOrNull()}'); // Parse error: FormatException: abc

  // Result.fromNullable
  Result<String, String> nonNull =
      Result.fromNullable("Hello", () => "Value was null");
  print('fromNullable non-null: ${nonNull.getOrNull()}'); // Hello

  String? nullableValue;
  Result<String, String> isNull =
      Result.fromNullable(nullableValue, () => "Value was null");
  print('fromNullable null: ${isNull.getErrorOrNull()}'); // Value was null

  // zipWith
  final Result<String, int> r1 = Success(10);
  final Result<String, String> r2 = Success(" apples");
  final Result<String, int> r3 = Failure("r3 failed");

  Result<String, String> zipSuccess =
      r1.zipWith(r2, (number, fruit) => "$number$fruit");
  print('zipSuccess: ${zipSuccess.getOrNull()}'); // "10 apples"

  Result<String, String> zipFailure1 =
      r3.zipWith(r2, (number, fruit) => "$number$fruit");
  print('zipFailure1: ${zipFailure1.getErrorOrNull()}'); // "r3 failed"

  Result<String, String> zipFailure2 = r1.zipWith(
      Failure<String, String>("r2 failed"), (number, fruit) => "$number$fruit");
  print('zipFailure2: ${zipFailure2.getErrorOrNull()}'); // "r2 failed"

  // Result.sequence
  final list1 = <Result<String, int>>[Success(1), Success(2), Success(3)];
  final seq1 = Result.sequence(list1);
  seq1.when(
    success: (data) => print('Sequence 1 success: $data'), // [1, 2, 3]
    failure: (error) => print('Sequence 1 failure: $error'),
  );

  final list2 = <Result<String, int>>[
    Success(1),
    Failure("Error in list"),
    Success(3)
  ];
  final seq2 = Result.sequence(list2);
  seq2.when(
    success: (data) => print('Sequence 2 success: $data'),
    failure: (error) => print('Sequence 2 failure: $error'), // Error in list
  );

  final list3 = <Result<String, int>>[];
  final seq3 = Result.sequence(list3);
  seq3.when(
    success: (data) => print('Sequence 3 success: $data'), // []
    failure: (error) => print('Sequence 3 failure: $error'),
  );
}
