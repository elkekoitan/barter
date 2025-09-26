# Complete Payment Provider Implementations

**Summary**: Remote payment data source redefines PaymentRequest and throws UnimplementedError for several providers.
**Impact**: Compile-time conflicts and runtime crashes when unsupported providers are selected.
**Recommended Steps**:
- Rename remote-layer DTOs (e.g., `RemotePaymentRequest`) or reuse domain entities to avoid collisions.
- Implement or safely guard Tosla, PayTR, BKM, Paycell, and Param flows (fall back to descriptive errors/UI locks).
- Document provider setup (API keys, callbacks) and add integration/unit tests per provider.
