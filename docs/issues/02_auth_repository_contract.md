# Consolidate AuthRepository Contract

**Summary**: AuthRepository is declared twice and RegisterRequest lacks confirmPassword while use cases expect it.
**Impact**: Compilation errors and broken register flow.
**Recommended Steps**:
- Merge the duplicate `AuthRepository` definitions into a single interface (split social login into a dedicated abstraction if needed).
- Add `confirmPassword` to `RegisterRequest` and propagate through UI/data layers.
- Import `firebase_auth` (or remove social-login placeholders) wherever `UserCredential` is required.
- Update repository implementations and tests to match the new contract.
