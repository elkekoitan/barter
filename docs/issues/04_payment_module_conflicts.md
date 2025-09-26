# Resolve Payment Module Conflicts

**Summary**: Payment BLoC uses conflicting `part` directives and `ProcessPaymentUsecase` redefines ValidationFailure.
**Impact**: Duplicate type definitions prevent compilation.
**Recommended Steps**:
- Decide on a single file-organization pattern: either keep `part` files with `part of` headers or use standalone imports, removing duplicates.
- Rename clashing types (e.g., event/state `PaymentFailed`) if required.
- Remove the duplicate `ValidationFailure` definition and reuse the shared one from `core/errors/failures.dart`.
