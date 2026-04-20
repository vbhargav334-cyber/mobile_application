class AppConstants {
  static const String appName = 'School App';

  /// If false, app uses in-memory mock data; if true, app uses Firebase.
  /// Toggle via --dart-define=USE_FIREBASE=true at build time.
  static const bool useFirebase =
      bool.fromEnvironment('USE_FIREBASE', defaultValue: false);

  static const String schoolName = 'Sunrise Public School';
  static const String academicYear = '2025-26';
}

enum UserRole { student, teacher, principal, parent, admin }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.principal:
        return 'Principal';
      case UserRole.parent:
        return 'Parent';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get key => name;

  static UserRole fromKey(String key) =>
      UserRole.values.firstWhere((r) => r.name == key, orElse: () => UserRole.student);
}
