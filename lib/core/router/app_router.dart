import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/admin_dashboard.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/common/announcements_screen.dart';
import '../../features/common/chat_screen.dart';
import '../../features/common/events_screen.dart';
import '../../features/common/notifications_screen.dart';
import '../../features/common/profile_screen.dart';
import '../../features/parent/parent_dashboard.dart';
import '../../features/parent/fees_pay_screen.dart';
import '../../features/principal/principal_dashboard.dart';
import '../../features/principal/staff_overview_screen.dart';
import '../../features/student/assignments_screen.dart';
import '../../features/student/attendance_screen.dart';
import '../../features/student/fees_screen.dart';
import '../../features/student/library_screen.dart';
import '../../features/student/marks_screen.dart';
import '../../features/student/student_dashboard.dart';
import '../../features/student/study_materials_screen.dart';
import '../../features/student/timetable_screen.dart';
import '../../features/teacher/attendance_marking_screen.dart';
import '../../features/teacher/leave_requests_screen.dart';
import '../../features/teacher/marks_upload_screen.dart';
import '../../features/teacher/teacher_dashboard.dart';
import '../constants/app_constants.dart';
import '../providers/providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(currentUserProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthListenable(ref),
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/student',
        builder: (_, __) => const StudentDashboard(),
        routes: [
          GoRoute(path: 'attendance', builder: (_, __) => const StudentAttendanceScreen()),
          GoRoute(path: 'marks', builder: (_, __) => const StudentMarksScreen()),
          GoRoute(path: 'timetable', builder: (_, __) => const StudentTimetableScreen()),
          GoRoute(path: 'assignments', builder: (_, __) => const StudentAssignmentsScreen()),
          GoRoute(path: 'fees', builder: (_, __) => const StudentFeesScreen()),
          GoRoute(path: 'library', builder: (_, __) => const StudentLibraryScreen()),
          GoRoute(path: 'study-materials', builder: (_, __) => const StudyMaterialsScreen()),
        ],
      ),
      GoRoute(
        path: '/teacher',
        builder: (_, __) => const TeacherDashboard(),
        routes: [
          GoRoute(path: 'attendance', builder: (_, __) => const AttendanceMarkingScreen()),
          GoRoute(path: 'marks-upload', builder: (_, __) => const MarksUploadScreen()),
          GoRoute(path: 'leave-requests', builder: (_, __) => const LeaveRequestsScreen()),
        ],
      ),
      GoRoute(
        path: '/principal',
        builder: (_, __) => const PrincipalDashboard(),
        routes: [
          GoRoute(path: 'staff', builder: (_, __) => const StaffOverviewScreen()),
        ],
      ),
      GoRoute(
        path: '/parent',
        builder: (_, __) => const ParentDashboard(),
        routes: [
          GoRoute(path: 'fees', builder: (_, __) => const ParentFeesPayScreen()),
        ],
      ),
      GoRoute(path: '/admin', builder: (_, __) => const AdminDashboard()),
      GoRoute(path: '/announcements', builder: (_, __) => const AnnouncementsScreen()),
      GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
    ],
    redirect: (context, state) {
      final loggedIn = authAsync.asData?.value != null;
      final loggingIn = state.matchedLocation == '/login';
      final splash = state.matchedLocation == '/';
      if (!loggedIn && !loggingIn && !splash) return '/login';
      if (loggedIn && (loggingIn || splash)) {
        return _homeForRole(authAsync.asData!.value!.role);
      }
      return null;
    },
  );
});

String _homeForRole(UserRole role) {
  switch (role) {
    case UserRole.student:
      return '/student';
    case UserRole.teacher:
      return '/teacher';
    case UserRole.principal:
      return '/principal';
    case UserRole.parent:
      return '/parent';
    case UserRole.admin:
      return '/admin';
  }
}

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(currentUserProvider, (_, __) => notifyListeners());
  }
}
