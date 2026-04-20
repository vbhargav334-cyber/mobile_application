import '../constants/app_constants.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? photoUrl;
  final String? classId;
  final List<String> childIds;
  final String? schoolId;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.photoUrl,
    this.classId,
    this.childIds = const [],
    this.schoolId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role.key,
        'photoUrl': photoUrl,
        'classId': classId,
        'childIds': childIds,
        'schoolId': schoolId,
      };

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        id: m['id'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String?,
        role: UserRoleX.fromKey(m['role'] as String? ?? 'student'),
        photoUrl: m['photoUrl'] as String?,
        classId: m['classId'] as String?,
        childIds: (m['childIds'] as List?)?.cast<String>() ?? const [],
        schoolId: m['schoolId'] as String?,
      );
}

class SchoolClass {
  final String id;
  final String name;
  final String section;
  final String classTeacherId;
  final List<String> studentIds;
  final List<String> subjectIds;
  const SchoolClass({
    required this.id,
    required this.name,
    required this.section,
    required this.classTeacherId,
    required this.studentIds,
    required this.subjectIds,
  });
}

class Subject {
  final String id;
  final String name;
  final String teacherId;
  final String classId;
  const Subject({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.classId,
  });
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String classId;
  final DateTime date;
  final bool present;
  final String? note;
  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.date,
    required this.present,
    this.note,
  });
}

class MarksRecord {
  final String id;
  final String studentId;
  final String subjectId;
  final String examName;
  final double marks;
  final double maxMarks;
  final DateTime uploadedAt;
  const MarksRecord({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.examName,
    required this.marks,
    required this.maxMarks,
    required this.uploadedAt,
  });

  double get percentage => maxMarks == 0 ? 0 : (marks / maxMarks) * 100;
}

class FeeRecord {
  final String id;
  final String studentId;
  final String title;
  final double amount;
  final double paid;
  final DateTime dueDate;
  final bool isPaid;
  const FeeRecord({
    required this.id,
    required this.studentId,
    required this.title,
    required this.amount,
    required this.paid,
    required this.dueDate,
    required this.isPaid,
  });

  double get remaining => (amount - paid).clamp(0, double.infinity);
}

class Announcement {
  final String id;
  final String title;
  final String body;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final String audience; // 'all' | 'class:<id>' | 'role:<role>'
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.audience,
  });
}

class Assignment {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String classId;
  final String teacherId;
  final DateTime dueDate;
  final List<String> attachments;
  const Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
    required this.dueDate,
    required this.attachments,
  });
}

class TimetableSlot {
  final String day; // Mon, Tue...
  final String startTime; // e.g., "09:00"
  final String endTime; // e.g., "09:45"
  final String subjectName;
  final String teacherName;
  final String room;
  const TimetableSlot({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subjectName,
    required this.teacherName,
    required this.room,
  });
}

class LeaveRequest {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime from;
  final DateTime to;
  final String reason;
  final String status; // pending / approved / rejected
  const LeaveRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
  });
}

class EventItem {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  const EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });
}

class ChatMessage {
  final String id;
  final String fromId;
  final String fromName;
  final String toId;
  final String body;
  final DateTime sentAt;
  const ChatMessage({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.toId,
    required this.body,
    required this.sentAt,
  });
}
