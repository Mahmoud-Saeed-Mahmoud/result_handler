/// Represents a failed result, containing an error of type [E].
class Failure<T, E> extends Result<T, E> {
  /// The error value.
  final E error;

  /// Creates a new [Failure] with the given error.
  const Failure(this.error);

  /// Binds the given function to the value of this result, if it is a success.

  /// If this result is a failure, the given function is not called and a new
  /// failure with the same error is returned. If this result is a success, the
  /// given function is called with the value of this result and the result of
  /// that call is returned as the result of this function.
  @override
  Result<R, E> bind<R>(Result<R, E> Function(T value) transform) {
    return Failure(error);
  }

  /// Transforms the value of this result by applying the given function to the
  /// value of this result, if it is a success.
  ///
  /// If this result is a failure, the given function is not called and a new
  /// failure with the same error is returned. If this result is a success, the
  /// given function is called with the value of this result and the result of
  /// that call is returned as the result of this function.
  ///
  /// The given function must return a [Result].
  @override
  Result<R, E> flatMap<R>(Result<R, E> Function(T value) transform) {
    return Failure(error);
  }

  /// Returns the value of this result if it is a success, or the result of
  /// calling the given function with the error of this result as argument if it
  /// is a failure.
  ///
  /// This function is useful for providing a default value when the result of
  /// an operation is not available. The given function is only called if the
  /// result is a failure.
  @override
  T getOrElse(T Function(E error) orElse) {
    // If the result is a failure, call the given function and return the result.
    // Otherwise, return the value of the result.
    return orElse(error);
  }

  /// Returns the value of this result if it is a success, or throws an error
  /// if it is a failure.
  ///
  /// This function is useful for providing a result that will be used
  /// immediately, in which case throwing an error if the result is not
  /// available is acceptable.
  @override
  T getOrThrow() {
    // Wrap the error in Exception before throwing it,
    //since the error might not be an object that can be thrown.
    throw Exception(error);
  }

  /// Maps the value of this result by applying the given function to the value
  /// of this result, if it is a success.
  ///
  /// If this result is a failure, the given function is not called and a new
  /// failure with the same error is returned. If this result is a success, the
  /// given function is called with the value of this result and the result of
  /// that call is returned as the result of this function.
  ///
  /// The given function must return a [Result].
  @override
  Result<R, E> map<R>(R Function(T value) transform) {
    // If the result is a failure, return a new failure with the same error.
    // Otherwise, return a new success with the transformed value.
    return Failure(error);
  }

  /// Maps the error of this result by applying the given function to the error
  /// of this result, if it is a failure.
  ///
  /// If this result is a success, the given function is not called and a new
  /// success with the same value is returned. If this result is a failure, the
  /// given function is called with the error of this result and the result of
  /// that call is returned as the result of this function.
  ///
  /// The given function must return a [Result].
  @override
  Result<T, R> mapFailure<R>(R Function(E error) transform) {
    // If the result is a failure, return a new failure with the transformed error.
    // Otherwise, return a new success with the same value.
    return Failure(transform(error));
  }

  /// Executes one of the given functions depending on the type of the [Result].
  ///
  /// If the result is a [Success], the [success] function is called with the
  /// value of the [Success] as argument and the result of that call is returned.
  ///
  /// If the result is a [Failure], the [failure] function is called with the
  /// error of the [Failure] as argument and the result of that call is returned.
  ///
  /// The given functions must return a value of type [R].
  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    // If the result is a failure, call the failure function and return the result.
    // Otherwise, call the success function and return the result.
    return failure(error);
  }
}

/// An abstract class representing the result of an operation, which can either be a [Success] or a [Failure].
///
/// [T] is the type of the value held by a [Success].
/// [E] is the type of the error held by a [Failure].
abstract class Result<T, E> {
  /// Creates a new [Result].
  const Result();

  /// Binds a function to the [Result]. If the result is a [Success],
  /// the function is applied to the value, returning a new [Result].
  /// If the result is a [Failure], the [Failure] is returned without modification.
  ///
  /// This is similar to [flatMap], but is more aligned to functional programming
  /// and allows you to compose the code and the chain of operations in a more descriptive way.
  ///
  /// [transform] is the function to bind to the [Success] value.
  Result<R, E> bind<R>(Result<R, E> Function(T value) transform);

  /// Applies a transformation function that also returns a `Result` to the value
  /// inside this `Result` if it's a `Success`. If the `Result` is a `Failure`, it is
  /// returned without the transformation being applied.
  ///
  /// This is useful for chaining operations that can fail.
  ///
  /// [transform] is the function to apply to the value.
  Result<R, E> flatMap<R>(Result<R, E> Function(T value) transform);

  /// Returns the value held by a [Success], or the result of executing [orElse]
  /// on a [Failure]'s error if the [Result] is a [Failure].
  ///
  /// [orElse] is the function to run on failure, it should return a default value.
  T getOrElse(T Function(E error) orElse);

  /// Returns the value held by a [Success], or throws the error wrapped in an
  /// `Exception` if the [Result] is a [Failure].
  T getOrThrow();

  /// Transforms the value inside a [Success] using the [transform] function.
  /// If the [Result] is a [Failure], it is returned without modification.
  ///
  /// [transform] is the function to apply to the success value.
  Result<R, E> map<R>(R Function(T value) transform);

  /// Transforms the error inside a [Failure] using the [transform] function.
  /// If the [Result] is a [Success], it is returned without modification.
  ///
  /// [transform] is the function to apply to the error.
  Result<T, R> mapFailure<R>(R Function(E error) transform);

  /// Executes either the [success] callback with the value if the [Result] is a
  /// [Success], or the [failure] callback with the error if the [Result] is a
  /// [Failure]. This is the equivalent of pattern matching for results.
  ///
  /// [success] is the function to call when the result is a [Success].
  /// [failure] is the function to call when the result is a [Failure].
  ///
  /// Returns the result of the called callback.
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  });
}

/// Represents a successful result, containing a value of type [T].
class Success<T, E> extends Result<T, E> {
  /// The successful value.
  final T data;

  /// Creates a new [Success] with the given value.
  const Success(this.data);

  /// Binds a function to the [Success]. The function is applied to the value
  /// of this [Success], returning a new [Result].
  ///
  /// This is similar to [flatMap], but is more aligned to functional
  /// programming and allows you to compose the code and the chain of
  /// operations in a more descriptive way.
  ///
  /// [transform] is the function to bind to the [Success] value.
  @override
  Result<R, E> bind<R>(Result<R, E> Function(T value) transform) {
    // Apply the given function to the value of this success.
    return transform(data);
  }

  /// Binds a function to the [Success] value, returning a new [Result].
  ///
  /// This is similar to [bind], but is more aligned to the concept of
  /// monads. The function is applied to the value of this [Success], and
  /// the result is returned as a new [Result].
  ///
  /// [transform] is the function to bind to the [Success] value.
  @override
  Result<R, E> flatMap<R>(Result<R, E> Function(T value) transform) {
    // Apply the given function to the value of this success.
    return transform(data);
  }

  /// Returns the value held by this [Success], or the result of executing [orElse]
  /// on the error of a [Failure] if the [Result] is a [Failure].
  ///
  /// [orElse] is the function to run on failure, it should return a default value.
  @override
  T getOrElse(T Function(E error) orElse) {
    // Since this is a success, return the value.
    return data;
  }

  /// Returns the value held by this [Success].
  ///
  /// If the [Result] is a [Failure], this will throw the error.
  @override
  T getOrThrow() {
    // Since this is a success, return the value.
    return data;
  }

  /// Applies a transformation to the value of this [Success].
  ///
  /// [transform] is the function to apply to the value of this [Success].
  ///
  /// Returns a new [Success] with the transformed value.
  @override
  Result<R, E> map<R>(R Function(T value) transform) {
    return Success(transform(data));
  }

  /// Maps the error of a [Failure] to a new type [R], without changing
  /// the result type [T].
  ///
  /// [transform] is the function to apply to the error of a [Failure].
  ///
  /// Since this is a [Success], the error is ignored, and a new
  /// [Success] is returned with the same value.
  @override
  Result<T, R> mapFailure<R>(R Function(E error) transform) {
    return Success(data);
  }

  /// Calls the [success] function with the value of this [Success] and returns its
  /// result.
  ///
  /// This is the equivalent of pattern matching for results.
  ///
  /// [success] is the function to call when the result is a [Success].
  /// [failure] is the function to call when the result is a [Failure], but it's
  /// ignored for [Success] values.
  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    // Since this is a success, call the success function with the value.
    return success(data);
  }
}
