# Generate Injectable Config

**Summary**: GetIt.init() is called without importing generated `injection_container.config.dart`.
**Impact**: Method `init` undefined for GetIt.
**Recommended Steps**:
- Add `part 'injection_container.config.dart';` to `lib/injection_container.dart`.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` and commit/track the generated file as per policy.
