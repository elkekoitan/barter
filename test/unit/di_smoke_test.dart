import 'package:flutter_test/flutter_test.dart';
import 'package:bogazici_barter/injection_container.dart';
import 'package:bogazici_barter/domain/repositories/auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('DI smoke test: setup and resolve core dependency', () async {
    await setupDependencies();

    final authRepo = getIt<AuthRepository>();
    expect(authRepo, isNotNull);
  });
}


