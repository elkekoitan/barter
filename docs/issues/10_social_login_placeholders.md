# Clarify Social Login Scope

**Summary**: Social login helpers rely on Firebase UserCredential but there are no implementations or imports.
**Impact**: Compilation/runtime breakage once duplicates are resolved.
**Recommended Steps**:
- Confirm MVP scope: either remove temporary social login APIs or implement them fully.
- If implementing, add necessary imports, data sources, and repository logic.
- Document configuration steps for each provider and ensure tests cover them.
