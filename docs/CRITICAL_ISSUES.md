# Critical Build-Blocking Issues

This document captures the fundamental problems that currently prevent the project from building or running, and it lists practical remediation steps for each item.

## 1. Dependency Injection Graph Is Broken
- Where: lib/injection_container.dart:1-304
- What: The file imports and registers many classes that are missing (cache_manager.dart, user_remote_datasource.dart, listing_remote_datasource.dart, barter_repository_impl.dart, etc.). It also registers abstract interfaces instead of concrete implementations and calls getIt.init() without importing the generated injection_container.config.dart.
- Impact: The project does not compile because GetIt cannot resolve undefined symbols.
- Fix Steps:
  1. Decide which modules belong in the MVP; add the missing classes or temporarily remove their registrations.
  2. Register concrete implementations (AuthRemoteDataSourceImpl, ListingRemoteDataSourceImpl, etc.) instead of interfaces.
  3. Add `part 'injection_container.config.dart';` and run `flutter pub run build_runner build --delete-conflicting-outputs`.
  4. Add a smoke test that boots the service locator so broken bindings fail fast.

## 2. Auth Repository Contract Duplicated
- Where: lib/domain/repositories/auth_repository.dart:1-220
- What: The file defines AuthRepository twice; the second definition reintroduces Firebase UserCredential methods and collides with the first. RegisterUseCase also expects request.confirmPassword even though RegisterRequest does not expose that property.
- Impact: Duplicate class definitions cause compile errors and the register flow cannot compile.
- Fix Steps:
  1. Merge both interfaces into one canonical AuthRepository (split social login into its own abstraction if needed).
  2. Extend RegisterRequest with confirmPassword and update the UI/data layers.
  3. Ensure firebase_auth is imported wherever UserCredential is referenced.

## 3. Auth Use Cases Misuse isLoggedIn
- Where: lib/domain/usecases/auth/login_usecase.dart:17-24, register_usecase.dart:17-24, verify_otp_usecase.dart:17-24
- What: Each use case treats _repository.isLoggedIn() as a Future<bool>, but the repository returns Future<Either<Failure, bool>>. This also performs the wrong responsibility (connectivity check).
- Impact: Compilation fails; even if fixed, the flow does not properly detect network availability.
- Fix Steps:
  1. Inject NetworkInfo and check networkInfo.isConnected before calling the repository.
  2. When isLoggedIn is actually needed, unwrap the Either explicitly and handle failures.
  3. Add unit tests that prove validation errors surface correctly.

## 4. Payment Module Naming Collisions
- Where: lib/presentation/blocs/payment/payment_bloc.dart, payment_event.dart, payment_state.dart
- What: payment_bloc.dart both imports and uses `part` directives with the same files, so classes like PaymentFailed are defined twice. ProcessPaymentUsecase also redefines ValidationFailure (already defined in core/errors/failures.dart).
- Impact: Duplicate type definitions block compilation.
- Fix Steps:
  1. Choose one strategy: either keep the files as real parts (remove explicit imports and add `part of` headers) or treat them as independent libraries (remove the `part` directives).
  2. Rename either the event or state PaymentFailed class if they remain separate files.
  3. Remove the duplicate ValidationFailure class and reuse the shared implementation.

## 5. Payment DTO Conflicts and Placeholders
- Where: lib/data/datasources/remote/payment_remote_datasource.dart
- What: The file declares another PaymentRequest type that collides with the domain entity, and every provider except Papara/Iyzico throws UnimplementedError.
- Impact: Compilation warnings escalate to errors; at runtime the app would crash whenever users select Tosla, PayTR, BKM Express, Paycell, or Param.
- Fix Steps:
  1. Rename the remote DTOs (for example RemotePaymentRequest) or use the domain models directly.
  2. Implement each provider flow or hide unsupported providers in the UI until they are ready.
  3. Document required API keys and add provider-specific tests.

## 6. Escrow Entity Import Mismatch
- Where: lib/domain/repositories/payment_repository.dart, lib/data/repositories/payment_repository_impl.dart
- What: Both files import domain/entities/escrow.dart, but EscrowEntity actually lives inside domain/entities/payment.dart.
- Impact: Missing file error at build time.
- Fix Steps:
  1. Move EscrowEntity into its own domain/entities/escrow.dart file or update imports to reference domain/entities/payment.dart.
  2. Update tests and mapping helpers once the model settles.

## 7. Missing Repository Implementations
- Where: lib/injection_container.dart:175-199
- What: The DI container registers UserRepositoryImpl, ListingRepositoryImpl, BarterRepositoryImpl, ChatRepositoryImpl, etc., but these classes do not exist under lib/data/repositories/.
- Impact: The project cannot compile because GetIt references missing types.
- Fix Steps:
  1. Either create the repository implementations with matching data sources or remove the registrations until they are delivered.
  2. Keep agents.txt in sync with the actual implementation status.

## 8. Missing Use Case Classes
- Where: lib/injection_container.dart:227-248
- What: Registrations for RejectOfferUseCase, CompleteBarterUseCase, CreateEscrowUseCase, ReleaseEscrowUseCase, and RefundPaymentUseCase exist, but corresponding files are absent from lib/domain/usecases/.
- Impact: Undefined symbol errors during compilation.
- Fix Steps:
  1. Add the missing use case files (with real logic and tests) or remove their registrations for now.
  2. Once created, wire them through repositories and blocs/widget flows.

## 9. Generated Injectable Extension Missing
- Where: lib/injection_container.dart:66
- What: getIt.init() relies on GetItInjectableX (generated into injection_container.config.dart) but that file is not generated or imported.
- Impact: Build error: method `init` is undefined for GetIt.
- Fix Steps:
  1. Add `part 'injection_container.config.dart';` to the file.
  2. Regenerate the config with build_runner and import it.

## 10. Social Login Placeholders
- Where: lib/domain/repositories/auth_repository.dart:167-201, lib/presentation/blocs/auth/auth_bloc.dart
- What: The duplicated AuthRepository exposes many social login helpers that rely on Firebase UserCredential but no imports or implementations exist.
- Impact: Even after resolving duplicates, the code will not compile or run until these methods are implemented.
- Fix Steps:
  1. Confirm whether social logins are in scope for the next milestone; if not, remove the placeholder API temporarily.
  2. If they are in scope, add the proper imports, data sources, and repository implementations.

## 11. Missing Data Source Files
- Where: lib/injection_container.dart:128-159
- What: Imports reference user_remote_datasource.dart, listing_remote_datasource.dart, and barter_remote_datasource.dart, but those files are not in the repo.
- Impact: The project fails to compile because the import targets are missing.
- Fix Steps:
  1. Add the missing remote data source implementations or remove the imports until the code exists.

## Suggested Order of Execution
1. Stabilise the DI layer (Issues 1, 7, 8, 9, 11).
2. Repair the authentication contract and use cases (Issues 2, 3, 10).
3. Resolve payment module conflicts and provider gaps (Issues 4 and 5).
4. Fix shared entity imports and add regression tests (Issue 6).

Keeping this document updated inside docs/CRITICAL_ISSUES.md will help onboard new contributors and ensure everyone understands the current blockers.
