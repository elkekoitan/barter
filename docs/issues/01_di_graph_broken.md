# Fix Dependency Injection Graph

**Summary**: lib/injection_container.dart imports and registers missing classes, uses interfaces instead of implementations, and lacks the generated injectable config.
**Impact**: Project fails to compile because GetIt cannot resolve dependencies.
**Recommended Steps**:
- Audit imports/registrations in `lib/injection_container.dart` and remove or implement missing modules (cache manager, user/listing/barter data sources, repository impls, etc.).
- Ensure each registration points to a concrete class (`AuthRemoteDataSourceImpl`, `ListingRepositoryImpl`, ...).
- Add `part 'injection_container.config.dart';` and regenerate with `flutter pub run build_runner build --delete-conflicting-outputs`.
- Add/execute a smoke test that calls `configureDependencies()` to guard against regressions.
