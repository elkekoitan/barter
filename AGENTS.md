# Repository Guidelines

## Project Structure & Module Organization
Store production code inside `lib/`, grouping it by agent responsibility such as `lib/auth/`, `lib/listing/`, or `lib/payment/`. Treat `agents.txt` as the architectural contract; mirror its subsections when introducing new modules and document deviations inline. Stage temporary research or spike code under `lib/_scratch/` and delete it before merging. Keep design notes or data contracts alongside the feature they support to simplify agent handoffs.

## Build, Test, and Development Commands
Run `flutter pub get` whenever dependencies change, then `dart run build_runner build --delete-conflicting-outputs` if code generation is involved. Use `flutter run --flavor dev` for interactive debugging and `flutter build apk --flavor prod` or `flutter build ios --config-only` before release approvals. Scaffold new components with Codex CLI recipes (`codex agent listing --with=media,delivery`) and sync multi-agent updates with `codex run agents --all`. Re-run `dart analyze` and `dart format --set-exit-if-changed .` prior to pushing.

## Coding Style & Naming Conventions
Adopt the official Dart style: two-space indentation, trailing commas on multi-line literals, and snake_case filenames such as `create_offer_page.dart`. Prefer PascalCase for classes and enums, and keep public method names descriptive yet concise. Document cross-agent APIs with brief doc comments and update `agents.txt` whenever the contract changes. Avoid committing generated or platform-specific artifacts.

## Testing Guidelines
Place tests under `test/agent_name/`, mirroring the structure under `lib/`. Target at least 85% coverage for each agent by running `flutter test --coverage`; attach the resulting `coverage/lcov.info` to the PR. Use descriptive test names like `whenOfferAccepted_updatesEscrowBalance`. Stub external services (Papara, İyzico, webhooks) so suites remain deterministic and fast.

## Commit & Pull Request Guidelines
Write imperative commit subjects under 72 characters (e.g., `Add barter escrow flow`). Reference the related agent or tracker ID in the body and list any generated files that were refreshed. Pull requests should contain: a concise summary, verification notes (commands run), and screenshots or screen recordings for UI changes. Link to the affected section in `agents.txt` to help reviewers trace the workflow update.

## Agent Workflow Tips
Start new efforts by cloning an established agent folder, adjusting the Codex CLI parameters, and documenting the intent in `agents.txt` before coding. Confirm inter-agent contracts in writing before merging, and schedule cross-agent refactors when all stakeholders have signed off on the updated flow.
