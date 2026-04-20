import '../constants/app_constants.dart';
import '../models/models.dart';

/// Hardcoded demo data so the app can be explored without any backend.
class MockData {
  static final List<AppUser> users = [
    const AppUser(
      id: 'u_stu_1',
      name: 'Arjun Reddy',
      email: 'arjun@demo.school',
      role: UserRole.student,
      phone: '+91 98765 00001',
      classId: 'c_10a',
      schoolId: 's1',
    ),
    const AppUser(
      id: 'u_stu_2',
      name: 'Priya Sharma',
      email: 'priya@demo.school',
      role: UserRole.student,
      classId: 'c_10a',
      schoolId: 's1',
    ),
    const AppUser(
      id: 'u_tea_1',
      name: 'Rajesh Kumar',
      email: 'rajesh@demo.school',
      role: UserRole.teacher,
      phone: '+91 98765 10001',
      schoolId: 's1',
    ),
    const AppUser(
      id: 'u_tea_2',
      name: 'Anita Rao',
      email: 'anita@demo.school',
      role: UserRole.teacher,
      schoolId: 's1',
    ),
    const AppUser(
      id: 'u_pri_1',
      name: 'Dr. Suresh Rao',
      email: 'principal@demo.school',
      role: UserRole.principal,
      schoolId: 's1',
    ),
    const AppUser(
      id: 'u_par_1',
      name: 'Ramesh Reddy',
      email: 'parent@demo.school',
      role: UserRole.parent,
      phone: '+91 98765 20001',
      childIds: ['u_stu_1'],
      schoolId: 's1',
    ),
    const AppUser(
      id: 'u_adm_1',
      name: 'Office Admin',
      email: 'admin@demo.school',
      role: UserRole.admin,
      schoolId: 's1',
    ),
  ];

  static AppUser userForRole(UserRole role) =>
      users.firstWhere((u) => u.role == role);

  static final List<SchoolClass> classes = [
    const SchoolClass(
      id: 'c_10a',
      name: 'Class 10',
      section: 'A',
      classTeacherId: 'u_tea_1',
      studentIds: ['u_stu_1', 'u_stu_2'],
      subjectIds: ['s_math', 's_sci', 's_eng', 's_soc', 's_tel'],
    ),
    const SchoolClass(
      id: 'c_10b',
      name: 'Class 10',
      section: 'B',
      classTeacherId: 'u_tea_2',
      studentIds: [],
      subjectIds: ['s_math', 's_sci', 's_eng'],
    ),
  ];

  static final List<Subject> subjects = [
    const Subject(id: 's_math', name: 'Mathematics', teacherId: 'u_tea_1', classId: 'c_10a'),
    const Subject(id: 's_sci', name: 'Science', teacherId: 'u_tea_2', classId: 'c_10a'),
    const Subject(id: 's_eng', name: 'English', teacherId: 'u_tea_2', classId: 'c_10a'),
    const Subject(id: 's_soc', name: 'Social Studies', teacherId: 'u_tea_1', classId: 'c_10a'),
    const Subject(id: 's_tel', name: 'Telugu', teacherId: 'u_tea_1', classId: 'c_10a'),
  ];

  static List<AttendanceRecord> attendanceForStudent(String studentId) {
    final now = DateTime.now();
    final records = <AttendanceRecord>[];
    for (int i = 0; i < 45; i++) {
      final d = now.subtract(Duration(days: i));
      if (d.weekday == DateTime.sunday) continue;
      records.add(AttendanceRecord(
        id: 'a_${studentId}_$i',
        studentId: studentId,
        classId: 'c_10a',
        date: DateTime(d.year, d.month, d.day),
        present: !(i % 11 == 0 || i % 17 == 0),
      ));
    }
    return records;
  }

  static List<MarksRecord> marksForStudent(String studentId) {
    final now = DateTime.now();
    return [
      MarksRecord(id: 'm1', studentId: studentId, subjectId: 's_math', examName: 'Unit Test 1', marks: 42, maxMarks: 50, uploadedAt: now.subtract(const Duration(days: 30))),
      MarksRecord(id: 'm2', studentId: studentId, subjectId: 's_sci', examName: 'Unit Test 1', marks: 45, maxMarks: 50, uploadedAt: now.subtract(const Duration(days: 29))),
      MarksRecord(id: 'm3', studentId: studentId, subjectId: 's_eng', examName: 'Unit Test 1', marks: 38, maxMarks: 50, uploadedAt: now.subtract(const Duration(days: 28))),
      MarksRecord(id: 'm4', studentId: studentId, subjectId: 's_soc', examName: 'Unit Test 1', marks: 40, maxMarks: 50, uploadedAt: now.subtract(const Duration(days: 27))),
      MarksRecord(id: 'm5', studentId: studentId, subjectId: 's_tel', examName: 'Unit Test 1', marks: 47, maxMarks: 50, uploadedAt: now.subtract(const Duration(days: 26))),
      MarksRecord(id: 'm6', studentId: studentId, subjectId: 's_math', examName: 'Mid Term', marks: 82, maxMarks: 100, uploadedAt: now.subtract(const Duration(days: 5))),
      MarksRecord(id: 'm7', studentId: studentId, subjectId: 's_sci', examName: 'Mid Term', marks: 89, maxMarks: 100, uploadedAt: now.subtract(const Duration(days: 4))),
      MarksRecord(id: 'm8', studentId: studentId, subjectId: 's_eng', examName: 'Mid Term', marks: 76, maxMarks: 100, uploadedAt: now.subtract(const Duration(days: 3))),
    ];
  }

  static List<FeeRecord> feesForStudent(String studentId) => [
        FeeRecord(
          id: 'f1',
          studentId: studentId,
          title: 'Term 1 Tuition Fee',
          amount: 25000,
          paid: 25000,
          dueDate: DateTime.now().subtract(const Duration(days: 60)),
          isPaid: true,
        ),
        FeeRecord(
          id: 'f2',
          studentId: studentId,
          title: 'Term 2 Tuition Fee',
          amount: 25000,
          paid: 10000,
          dueDate: DateTime.now().add(const Duration(days: 10)),
          isPaid: false,
        ),
        FeeRecord(
          id: 'f3',
          studentId: studentId,
          title: 'Bus Fee',
          amount: 8000,
          paid: 0,
          dueDate: DateTime.now().add(const Duration(days: 20)),
          isPaid: false,
        ),
      ];

  static final List<Announcement> announcements = [
    Announcement(
      id: 'an1',
      title: 'Annual Day Celebration',
      body: 'Annual day will be celebrated on 25th of this month. All students must attend in uniform.',
      authorId: 'u_pri_1',
      authorName: 'Principal',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      audience: 'all',
    ),
    Announcement(
      id: 'an2',
      title: 'Mid Term Results Released',
      body: 'Mid-term results are now available in the marks section.',
      authorId: 'u_tea_1',
      authorName: 'Rajesh Kumar',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      audience: 'class:c_10a',
    ),
    Announcement(
      id: 'an3',
      title: 'Parent-Teacher Meeting',
      body: 'PTM scheduled for Saturday 10am-1pm. Please be on time.',
      authorId: 'u_pri_1',
      authorName: 'Principal',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      audience: 'role:parent',
    ),
  ];

  static final List<Assignment> assignments = [
    Assignment(
      id: 'as1',
      title: 'Algebra Problem Set 4',
      description: 'Complete exercises 4.1 to 4.5 from NCERT.',
      subjectId: 's_math',
      classId: 'c_10a',
      teacherId: 'u_tea_1',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      attachments: [],
    ),
    Assignment(
      id: 'as2',
      title: 'Science Lab Report - Acids & Bases',
      description: 'Write a lab report summarising the experiment performed in class.',
      subjectId: 's_sci',
      classId: 'c_10a',
      teacherId: 'u_tea_2',
      dueDate: DateTime.now().add(const Duration(days: 6)),
      attachments: [],
    ),
    Assignment(
      id: 'as3',
      title: 'English Essay - My Hero',
      description: '300 word essay.',
      subjectId: 's_eng',
      classId: 'c_10a',
      teacherId: 'u_tea_2',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      attachments: [],
    ),
  ];

  static final List<TimetableSlot> timetable = [
    const TimetableSlot(day: 'Mon', startTime: '09:00', endTime: '09:45', subjectName: 'Mathematics', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Mon', startTime: '09:45', endTime: '10:30', subjectName: 'Science', teacherName: 'Anita Rao', room: 'Lab 2'),
    const TimetableSlot(day: 'Mon', startTime: '10:45', endTime: '11:30', subjectName: 'English', teacherName: 'Anita Rao', room: 'Room 12'),
    const TimetableSlot(day: 'Mon', startTime: '11:30', endTime: '12:15', subjectName: 'Social Studies', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Tue', startTime: '09:00', endTime: '09:45', subjectName: 'Science', teacherName: 'Anita Rao', room: 'Lab 2'),
    const TimetableSlot(day: 'Tue', startTime: '09:45', endTime: '10:30', subjectName: 'Mathematics', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Tue', startTime: '10:45', endTime: '11:30', subjectName: 'Telugu', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Wed', startTime: '09:00', endTime: '09:45', subjectName: 'English', teacherName: 'Anita Rao', room: 'Room 12'),
    const TimetableSlot(day: 'Wed', startTime: '09:45', endTime: '10:30', subjectName: 'Social Studies', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Thu', startTime: '09:00', endTime: '09:45', subjectName: 'Mathematics', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Thu', startTime: '09:45', endTime: '10:30', subjectName: 'Science', teacherName: 'Anita Rao', room: 'Lab 2'),
    const TimetableSlot(day: 'Fri', startTime: '09:00', endTime: '09:45', subjectName: 'Telugu', teacherName: 'Rajesh Kumar', room: 'Room 12'),
    const TimetableSlot(day: 'Fri', startTime: '09:45', endTime: '10:30', subjectName: 'English', teacherName: 'Anita Rao', room: 'Room 12'),
    const TimetableSlot(day: 'Sat', startTime: '09:00', endTime: '09:45', subjectName: 'Library', teacherName: '—', room: 'Library'),
  ];

  static final List<EventItem> events = [
    EventItem(id: 'e1', title: 'Annual Sports Day', description: 'Inter-class tournament.', date: DateTime.now().add(const Duration(days: 12))),
    EventItem(id: 'e2', title: 'Science Exhibition', description: 'Projects from Class 9 & 10.', date: DateTime.now().add(const Duration(days: 25))),
    EventItem(id: 'e3', title: 'Holiday - Dussehra', description: 'School closed.', date: DateTime.now().add(const Duration(days: 45))),
  ];

  static final List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      id: 'l1',
      studentId: 'u_stu_1',
      studentName: 'Arjun Reddy',
      from: DateTime.now().add(const Duration(days: 2)),
      to: DateTime.now().add(const Duration(days: 3)),
      reason: 'Family function',
      status: 'pending',
    ),
    LeaveRequest(
      id: 'l2',
      studentId: 'u_stu_2',
      studentName: 'Priya Sharma',
      from: DateTime.now().subtract(const Duration(days: 5)),
      to: DateTime.now().subtract(const Duration(days: 4)),
      reason: 'Fever',
      status: 'approved',
    ),
  ];
}
