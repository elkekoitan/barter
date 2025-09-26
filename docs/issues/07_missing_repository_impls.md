# Add Missing Repository Implementations

**Summary**: DI registers User/Listing/Barter/Chat repository implementations that are not present.
**Impact**: GetIt fails to resolve dependencies; build breaks.
**Recommended Steps**:
- Implement the missing repositories under `lib/data/repositories/` with appropriate data sources.
- If implementations are out of scope, remove/comment the registrations until they exist.
- Update `agents.txt` to reflect the true delivery status.
