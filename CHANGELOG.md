## 1.0.0

- First release.

## 1.0.1

- Edit description.

## 1.0.2

- Edit readme.

## 1.2.0

### Changed

- **Reversed Generic Type Parameters in `Result` Class Hierarchy:**
  - The generic type parameters in the `Result` abstract class and its concrete subclasses, `Failure` and `Success`, have been reversed.
  - **Previous:** `Result<Success, Error>`
  - **New:** `Result<Error, Success>`
  - This change affects the following classes and their method signatures:
    - `abstract class Result<E, T>`
    - `class Failure<E, T> extends Result<E, T>`
    - `class Success<E, T> extends Result<E, T>`
  - **Impact:**
    - The order of type parameters when creating `Result`, `Failure`, and `Success` instances is now `Result<ErrorType, SuccessType>`.
    - All methods in these classes that used `T` and `E` have been updated to reflect the change.
  - **Reason:**
    - Aligns with the common functional programming convention of specifying error type first and success type second in result types.
    - Provides a more intuitive mental model for developers when dealing with potential failures.
  - **Migration:**
    - Existing code utilizing the `Result` class will need to update their generic type parameters accordingly (e.g., `Result<int, String>` becomes `Result<String, int>`).
    - No functionality is changed other than type parameter order, so the code should work the same way after the fix, providing the types are updated correctly.

## 1.2.1

- **Updated Dart SDK Constraint:**
  - Extended SDK compatibility to support version 3.6.1
  - Updated constraint from '>=3.0.0 <=3.6.0' to '>=3.0.0 <=3.6.1'

## 1.2.2

- **Updated Dart SDK Constraint:**
  - Extended SDK compatibility to support version 3.6.1
  - Updated constraint from '>=3.0.0 <=4.0.0' to '>=3.0.0 <=4.0.0'

## 1.3.0

### Added

- **Enhanced Result Type with New Features:**
  - **Convenience Getters:**
    - `isSuccess`: Boolean getter to check if result is a success
    - `isFailure`: Boolean getter to check if result is a failure
    - `getOrNull()`: Returns the success value or null if failure
  - **Static Factory Methods:**
    - `Result.tryCatch()`: Safely execute a function and catch exceptions
    - `Result.tryCatchAsync()`: Async version of tryCatch for Future operations
    - `Result.fromNullable()`: Convert nullable values to Result with custom error
  - **Side-Effect Methods:**
    - `tap()`: Execute side effects on success values without modifying the result
    - `tapError()`: Execute side effects on failure values without modifying the result
  - **Error Recovery:**
    - `orElse()`: Provide alternative Result when current is failure
    - `recover()`: Transform failure to success with recovery function
    - `recoverWith()`: Transform failure to new Result with recovery function
  - **Filtering and Validation:**
    - `filterOrElse()`: Filter success values with predicate, convert to failure if not matching
  - **Collection Operations:**
    - `Result.sequence()`: Convert List<Result> to Result<List> (fails fast on first error)
    - `Result.partition()`: Separate list of Results into successes and failures
  - **Combining Results:**
    - `zipWith()`: Combine two Results using a function
  - **Async Operations:**
    - `mapAsync()`: Transform success value asynchronously
    - `flatMapAsync()`: Chain async operations that return Results
  - **Unit Type:**
    - Added `Unit` class for operations without meaningful return values
    - Provides `const Unit()` for consistent void operation handling
  - **Enhanced Debugging:**
    - Improved `toString()` implementations for better debugging experience
    - Added `hashCode` and equality implementations

### Changed

- **Updated Documentation:**
  - Comprehensive README with all new features and usage examples
  - Organized API documentation by functionality categories
  - Enhanced code examples showcasing functional composition patterns
  - Added real-world scenarios for validation, error recovery, and async operations
