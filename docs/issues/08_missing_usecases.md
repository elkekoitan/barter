# Create Missing Use Case Classes

**Summary**: DI references use cases (RejectOffer, CompleteBarter, Create/Release/Refund Escrow) that are absent.
**Impact**: Undefined symbol errors at compile time.
**Recommended Steps**:
- Add the missing use case files under `lib/domain/usecases/` with real logic and tests.
- Wire them through repositories and presentation layer (BLoCs/UI).
- If out of scope for now, remove the registrations until implemented.
