# Align Escrow Entity Imports

**Summary**: EscrowEntity is imported from a non-existent file; actual definition lives in `domain/entities/payment.dart`.
**Impact**: Missing file errors during build.
**Recommended Steps**:
- Either move `EscrowEntity` into `domain/entities/escrow.dart` or update all imports to reference the actual location.
- Update mappers/tests to use the correct import path.
