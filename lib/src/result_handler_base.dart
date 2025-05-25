/// Represents a failed result, containing an error of type [E].
/// [E] is the type of the error.
/// [T] is the type of the success value (unused in Failure but part of the Result contract).
class Failure<E, T> extends Result<E, T> {
  /// The error value.
  final E error;

  /// Creates a new [Failure] with the given error.
  const Failure(this.error);

  @override
  int get hashCode => error.hashCode;

  @override
  bool get isFailure => true;

  // --- New Feature Implementations ---

  @override
  bool get isSuccess => false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<E, T> &&
          runtimeType == other.runtimeType &&
          error == other.error; // Consider deep equality if E is complex.

  @override
  Result<E, R> bind<R>(Result<E, R> Function(T value) transform) {
    // Failure state, so bypass the transform and return a new Failure with the same error.
    // The type R indicates the success type of the *potential* new Result.
    return Failure<E, R>(error);
  }

  @override
  Result<E, T> filterOrElse(
      bool Function(T value) predicate, E Function(T value) errorIfFalse) {
    // Already a Failure, so no filtering to apply.
    return this;
  }

  @override
  Result<E, R> flatMap<R>(Result<E, R> Function(T value) transform) {
    // Failure state, so bypass the transform.
    return Failure<E, R>(error);
  }

  @override
  E? getErrorOrNull() => error;

  @override
  T getOrElse(T Function(E error) orElse) {
    // If the result is a failure, call the given function and return the result.
    return orElse(error);
  }

  @override
  T? getOrNull() => null;

  @override
  T getOrThrow() {
    // Wrap the error in Exception before throwing it,
    // since the error itself might not be an object that can be directly thrown
    // or to provide a common exception type.
    throw Exception(error
        .toString()); // Or just `throw error;` if E is always an Exception type.
  }

  @override
  Result<E, R> map<R>(R Function(T value) transform) {
    // Failure state, so bypass the transform.
    return Failure<E, R>(error);
  }

  @override
  Result<R, T> mapFailure<R>(R Function(E error) transform) {
    // Apply the transform to the error and wrap it in a new Failure.
    // The type T for the success value remains unchanged.
    return Failure<R, T>(transform(error));
  }

  @override
  Result<E, T> orElse(Result<E, T> Function(E error) recoveryFn) {
    // This is a Failure, attempt recovery by calling recoveryFn.
    return recoveryFn(error);
  }

  @override
  Result<E, T> tap(void Function(T value) fn) {
    // No success value to tap, so do nothing and return this Failure object.
    return this;
  }

  @override
  Result<E, T> tapError(void Function(E error) fn) {
    // Execute the function with the error for side effects.
    fn(error);
    // Return this Failure object.
    return this;
  }

  @override
  String toString() => 'Failure($error)';

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    // If the result is a failure, call the failure function and return the result.
    return failure(error);
  }

  @override
  Result<E, R> zipWith<U, R>(
      Result<E, U> other, R Function(T a, U b) combiner) {
    // This is a Failure, so the combined result is this Failure.
    // We need to cast to Failure<E,R> to match the return type.
    return Failure<E, R>(error);
  }
}

/// An abstract class representing the result of an operation, which can either
/// be a [Success] or a [Failure].
///
/// [E] is the type of the error held by a [Failure].
/// [T] is the type of the value held by a [Success].
abstract class Result<E, T> {
  /// Creates a new [Result].
  const Result();

  // --- Original Methods (with updated docs if needed) ---

  /// Returns `true` if this [Result] is a [Failure], `false` otherwise.
  bool get isFailure;

  /// Returns `true` if this [Result] is a [Success], `false` otherwise.
  bool get isSuccess;

  /// Binds a function to the [Result]. If the result is a [Success],
  /// the function is applied to the value, returning a new [Result].
  /// If the result is a [Failure], the [Failure] is returned without modification.
  ///
  /// This is similar to [flatMap], but is more aligned to functional programming
  /// and allows you to compose the code and the chain of operations in a more descriptive way.
  ///
  /// [transform] is the function to bind to the [Success] value.
  /// Returns a new [Result] based on the transformation.
  Result<E, R> bind<R>(Result<E, R> Function(T value) transform);

  /// If this is a [Success] and its value satisfies the [predicate], returns this [Success].
  /// If it's a [Success] but the value does not satisfy the [predicate], returns a [Failure]
  /// with the error produced by [errorIfFalse] (using the original success value).
  /// If this is already a [Failure], it's returned unchanged.
  ///
  /// [predicate] A function to test the success value.
  /// [errorIfFalse] A function that produces an error of type [E] if the predicate is false.
  /// Returns a [Result<E, T>].
  Result<E, T> filterOrElse(
      bool Function(T value) predicate, E Function(T value) errorIfFalse);

  /// Applies a transformation function that also returns a `Result` to the value
  /// inside this `Result` if it's a `Success`. If the `Result` is a `Failure`, it is
  /// returned without the transformation being applied.
  ///
  /// This is useful for chaining operations that can fail.
  ///
  /// [transform] is the function to apply to the value. It must return a [Result].
  /// Returns a new [Result] based on the transformation.
  Result<E, R> flatMap<R>(Result<E, R> Function(T value) transform);

  /// Returns the error value if this is a [Failure], otherwise returns `null`.
  E? getErrorOrNull();

  /// Returns the value held by a [Success], or the result of executing [orElse]
  /// on a [Failure]'s error if the [Result] is a [Failure].
  ///
  /// [orElse] is the function to run on failure, it should return a default value of type [T].
  /// Returns the success value or the result of [orElse].
  T getOrElse(T Function(E error) orElse);

  // --- New Features ---

  /// Returns the success value if this is a [Success], otherwise returns `null`.
  ///
  /// This is useful for contexts where `null` can represent the absence of a
  /// valid result, but typically `getOrElse` or `when` are preferred for safety.
  T? getOrNull();

  /// Returns the value held by a [Success], or throws the error wrapped in an
  /// [Exception] if the [Result] is a [Failure].
  ///
  /// Use this when you expect a success and consider a failure an exceptional case.
  /// Returns the success value. Throws if this is a [Failure].
  T getOrThrow();

  /// Transforms the value inside a [Success] using the [transform] function.
  /// If the [Result] is a [Failure], it is returned without modification.
  ///
  /// [transform] is the function to apply to the success value. It returns a new value of type [R].
  /// Returns a new [Result] with the transformed value if this is a [Success],
  /// or the original [Failure].
  Result<E, R> map<R>(R Function(T value) transform);

  /// Transforms the error inside a [Failure] using the [transform] function.
  /// If the [Result] is a [Success], it is returned without modification.
  ///
  /// [transform] is the function to apply to the error. It returns a new error value of type [R].
  /// Returns a new [Result] with the transformed error if this is a [Failure],
  /// or the original [Success].
  Result<R, T> mapFailure<R>(R Function(E error) transform);

  /// If this is a [Failure], applies the [recoveryFn] to the error.
  /// The [recoveryFn] itself returns a [Result], allowing an attempt to recover
  /// from the failure with an alternative operation.
  /// If this is a [Success], it is returned unchanged.
  ///
  /// [recoveryFn] A function that takes the error and returns a new [Result<E, T>].
  /// Returns the original [Success] or the result of [recoveryFn].
  Result<E, T> orElse(Result<E, T> Function(E error) recoveryFn);

  /// If this is a [Success], executes the given function [fn] with the success value
  /// for side effects (e.g., logging) and then returns this original [Success] object.
  /// If this is a [Failure], [fn] is not called and this [Failure] is returned.
  ///
  /// [fn] The function to execute with the success value.
  /// Returns this [Result] object.
  Result<E, T> tap(void Function(T value) fn);

  /// If this is a [Failure], executes the given function [fn] with the error value
  /// for side effects (e.g., logging) and then returns this original [Failure] object.
  /// If this is a [Success], [fn] is not called and this [Success] is returned.
  ///
  /// [fn] The function to execute with the error value.
  /// Returns this [Result] object.
  Result<E, T> tapError(void Function(E error) fn);

  /// Executes either the [success] callback with the value if the [Result] is a
  /// [Success], or the [failure] callback with the error if the [Result] is a
  /// [Failure]. This is the equivalent of pattern matching for results.
  ///
  /// [success] is the function to call when the result is a [Success].
  /// [failure] is the function to call when the result is a [Failure].
  ///
  /// Returns the result of the called callback, which is of type [R].
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  });

  /// Combines this [Result] with another [Result] (`other`).
  ///
  /// If both this [Result] and `other` are [Success], the `combiner` function is
  /// applied to their values, and a new [Success] containing the result is returned.
  /// If either this [Result] or `other` (or both) is a [Failure], the first
  /// encountered [Failure] is returned.
  ///
  /// [other] The other [Result] to combine with.
  /// [combiner] A function that takes the success values of this [Result] and `other`,
  /// and returns a new value of type [R].
  /// Returns a [Result<E, R>].
  Result<E, R> zipWith<U, R>(Result<E, U> other, R Function(T a, U b) combiner);

  /// Factory method to create a [Result] from a nullable value.
  ///
  /// If [value] is not `null`, a [Success<E, T>] containing the value is returned.
  /// If [value] is `null`, [errorIfNull] is called to produce an error of type [E],
  /// which is then wrapped in a [Failure<E, T>].
  ///
  /// Note: [T] must be a non-nullable type (`T extends Object`).
  ///
  /// [value] The nullable value of type [T?].
  /// [errorIfNull] A function that produces an error of type [E] if [value] is null.
  /// Returns a [Result<E, T>].
  static Result<E, T> fromNullable<E, T extends Object>(
    T? value,
    E Function() errorIfNull,
  ) {
    if (value != null) {
      return Success(value);
    } else {
      return Failure(errorIfNull());
    }
  }

  /// Transforms an `Iterable<Result<E, T>>` into a `Result<E, List<T>>`.
  ///
  /// If all [Result] instances in the [results] iterable are [Success],
  /// this method returns a [Success] containing a [List<T>] of all the success values
  /// in their original order.
  /// If any [Result] instance in the [results] iterable is a [Failure],
  /// this method short-circuits and returns the first encountered [Failure].
  /// An empty iterable will result in a `Success([])`.
  ///
  /// [results] An iterable of [Result<E, T>] instances.
  /// Returns a [Result<E, List<T>>].
  static Result<E, List<T>> sequence<E, T>(Iterable<Result<E, T>> results) {
    final successfulValues = <T>[];
    for (final result in results) {
      if (result.isFailure) {
        // Explicitly cast to Failure to access the error.
        // This is safe due to the isFailure check.
        return Failure((result as Failure<E, T>).error);
      }
      // Explicitly cast to Success to access data.
      // This is safe because if it were a Failure, we would have returned above.
      successfulValues.add((result as Success<E, T>).data);
    }
    return Success(successfulValues);
  }

  /// Factory method to create a [Result] by executing a synchronous function [fn].
  ///
  /// If [fn] completes successfully, its result is wrapped in a [Success].
  /// If [fn] throws an exception, [onError] is called with the caught error and
  /// stack trace to produce an error value of type [E], which is then wrapped
  /// in a [Failure].
  ///
  /// [fn] The synchronous function to execute.
  /// [onError] A function that converts a caught [Object] and [StackTrace] into an error of type [E].
  /// Returns a [Result<E, T>].
  static Result<E, T> tryCatch<E, T>(
    T Function() fn,
    E Function(Object error, StackTrace stackTrace) onError,
  ) {
    try {
      return Success(fn());
    } catch (e, s) {
      return Failure(onError(e, s));
    }
  }

  /// Factory method to create a [Result] by executing an asynchronous function [fn].
  ///
  /// If the [Future] returned by [fn] completes successfully, its result is wrapped in a [Success].
  /// If the [Future] or [fn] itself throws an exception, [onError] is called with the
  /// caught error and stack trace to produce an error value of type [E], which is then wrapped
  /// in a [Failure].
  ///
  /// [fn] The asynchronous function (returning a [Future<T>]) to execute.
  /// [onError] A function that converts a caught [Object] and [StackTrace] into an error of type [E].
  /// Returns a [Future<Result<E, T>>].
  static Future<Result<E, T>> tryCatchAsync<E, T>(
    Future<T> Function() fn,
    E Function(Object error, StackTrace stackTrace) onError,
  ) async {
    try {
      return Success(await fn());
    } catch (e, s) {
      return Failure(onError(e, s));
    }
  }
}

/// Represents a successful result, containing a value of type [T].
/// [E] is the type of the error (unused in Success but part of the Result contract).
/// [T] is the type of the success value.
class Success<E, T> extends Result<E, T> {
  /// The successful value.
  final T data;

  /// Creates a new [Success] with the given value.
  const Success(this.data);

  @override
  int get hashCode => data.hashCode;

  @override
  bool get isFailure => false;

  // --- New Feature Implementations ---

  @override
  bool get isSuccess => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<E, T> &&
          runtimeType == other.runtimeType &&
          data == other.data; // Consider deep equality if T is complex.

  @override
  Result<E, R> bind<R>(Result<E, R> Function(T value) transform) {
    // Apply the given function to the value of this success.
    return transform(data);
  }

  @override
  Result<E, T> filterOrElse(
      bool Function(T value) predicate, E Function(T value) errorIfFalse) {
    if (predicate(data)) {
      // Predicate holds, return this Success.
      return this;
    } else {
      // Predicate failed, return a Failure with the provided error.
      return Failure(errorIfFalse(data));
    }
  }

  @override
  Result<E, R> flatMap<R>(Result<E, R> Function(T value) transform) {
    // Apply the given function to the value of this success.
    return transform(data);
  }

  @override
  E? getErrorOrNull() => null;

  @override
  T getOrElse(T Function(E error) orElse) {
    // Since this is a success, return the value.
    return data;
  }

  @override
  T? getOrNull() => data;

  @override
  T getOrThrow() {
    // Since this is a success, return the value.
    return data;
  }

  @override
  Result<E, R> map<R>(R Function(T value) transform) {
    // Transform the success value and wrap it in a new Success.
    return Success(transform(data));
  }

  @override
  Result<R, T> mapFailure<R>(R Function(E error) transform) {
    // Success has no error to map, so return this success with the new error type.
    // The actual error type R is only relevant for the Failure case.
    return Success(data);
  }

  @override
  Result<E, T> orElse(Result<E, T> Function(E error) recoveryFn) {
    // This is a Success, no need to recover.
    return this;
  }

  @override
  Result<E, T> tap(void Function(T value) fn) {
    // Execute the function with the data for side effects.
    fn(data);
    // Return this Success object.
    return this;
  }

  @override
  Result<E, T> tapError(void Function(E error) fn) {
    // No error to tap, so do nothing and return this Success object.
    return this;
  }

  @override
  String toString() => 'Success($data)';

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    // Since this is a success, call the success function with the value.
    return success(data);
  }

  @override
  Result<E, R> zipWith<U, R>(
      Result<E, U> other, R Function(T a, U b) combiner) {
    // This is Success(a). Now we need to check 'other'.
    // We can use other.map to achieve this:
    // If 'other' is Success(b), other.map will call combiner(a, b) and wrap it in Success.
    // If 'other' is Failure(e), other.map will return Failure(e).
    return other.map((uValue) => combiner(data, uValue));
  }
}

/// Represents a unit type, indicating that an operation completed successfully
/// but does not yield a meaningful value.
/// This is often used in `Result<E, Unit>` for operations whose success
/// is simply the absence of an error (e.g., a save operation).
class Unit {
  const Unit();

  @override
  int get hashCode => 0; // All Unit instances are considered equal

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  String toString() => 'Unit()';
}
