import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/domain/models/app_user.dart';

void main() {
  group('AppUser', () {
    test('isAdmin returns true when role is admin', () {
      final user = AppUser(id: '1', email: 'admin@test.com', role: 'admin');
      expect(user.isAdmin, isTrue);
    });

    test('isAdmin returns false when role is user', () {
      final user = AppUser(id: '2', email: 'user@test.com', role: 'user');
      expect(user.isAdmin, isFalse);
    });

    test('isAdmin returns false when role is default (user)', () {
      final user = AppUser(id: '3', email: 'default@test.com');
      expect(user.isAdmin, isFalse);
    });
  });
}
