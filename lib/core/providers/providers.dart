import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/mock_data.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges();
});

/// Synchronous access to the currently signed-in user (nullable).
final signedInUserProvider = Provider<AppUser?>((ref) {
  final async = ref.watch(currentUserProvider);
  return async.asData?.value;
});

/// Announcements (demo).
final announcementsProvider = Provider<List<Announcement>>(
  (ref) => MockData.announcements,
);

final eventsProvider = Provider<List<EventItem>>((ref) => MockData.events);

final classesProvider = Provider<List<SchoolClass>>((ref) => MockData.classes);

final subjectsProvider = Provider<List<Subject>>((ref) => MockData.subjects);

final usersProvider = Provider<List<AppUser>>((ref) => MockData.users);

final leaveRequestsProvider = Provider<List<LeaveRequest>>(
  (ref) => MockData.leaveRequests,
);
