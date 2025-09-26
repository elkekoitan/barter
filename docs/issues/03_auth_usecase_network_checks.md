# Fix Auth Use Case Connectivity Checks

**Summary**: Auth use cases treat `_repository.isLoggedIn()` as a boolean connectivity probe.
**Impact**: Compilation failure and incorrect network handling.
**Recommended Steps**:
- Inject `NetworkInfo` into login/register/verify OTP use cases and use `networkInfo.isConnected` for connectivity validation.
- Unwrap the `Either` returned by `isLoggedIn()` only when session state is actually needed.
- Add unit tests to verify validation errors and failure handling.
