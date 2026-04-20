import 'dart:async';

import '../constants/app_constants.dart';
import '../models/models.dart';
import 'mock_data.dart';

/// Very light-weight authentication abstraction.
///
/// In demo mode we just pick a mock user by role. In real mode this is where
/// Firebase Auth calls would go; we keep the API role-based so it's easy to
/// plug in FirebaseAuth without changing callers.
class AuthService {
  AppUser? _current;
  final _controller = StreamController<AppUser?>.broadcast();

  AppUser? get currentUser => _current;
  Stream<AppUser?> authStateChanges() => _controller.stream;

  Future<AppUser> signInWithRole(UserRole role) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _current = MockData.userForRole(role);
    _controller.add(_current);
    return _current!;
  }

  Future<AppUser> signInWithEmail(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final match = MockData.users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => MockData.users.first,
    );
    _current = match;
    _controller.add(_current);
    return _current!;
  }

  Future<void> signOut() async {
    _current = null;
    _controller.add(null);
  }

  bool get isFirebaseEnabled => AppConstants.useFirebase;
}
