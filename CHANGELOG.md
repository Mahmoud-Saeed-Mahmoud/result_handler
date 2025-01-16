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

- **Updated Dart SDK**