# Firestore Schema

Top-level collections used by School App.

## `users/{uid}`
```
{
  id: string,
  name: string,
  email: string,
  phone?: string,
  role: 'student' | 'teacher' | 'principal' | 'parent' | 'admin',
  photoUrl?: string,
  classId?: string,          // for students + class teachers
  childIds?: string[],       // for parents
  schoolId: string,
  createdAt: timestamp,
}
```

## `classes/{classId}`
```
{
  id, name, section,
  classTeacherId: uid,
  studentIds: uid[],
  subjectIds: string[],
  schoolId: string,
}
```

## `subjects/{subjectId}`
```
{ id, name, teacherId, classId, schoolId }
```

## `attendance/{id}`
One doc per (student, date). Composite id e.g. `${classId}_${date}_${studentId}`.
```
{
  studentId, classId,
  date: timestamp,
  present: bool,
  note?: string,
  markedBy: uid,
  schoolId,
}
```

## `marks/{id}`
```
{
  studentId, subjectId, classId,
  examName: string,
  marks: number,
  maxMarks: number,
  uploadedAt: timestamp,
  uploadedBy: uid,
  schoolId,
}
```

## `fees/{id}`
```
{
  studentId,
  title, amount, paid,
  dueDate: timestamp,
  isPaid: bool,
  schoolId,
}
```

## `announcements/{id}`
```
{
  title, body,
  authorId, authorName,
  createdAt: timestamp,
  audience: 'all' | 'class:<classId>' | 'role:<role>',
  schoolId,
}
```

## `assignments/{id}`
```
{
  title, description,
  subjectId, classId, teacherId,
  dueDate: timestamp,
  attachments: string[],  // storage paths
  schoolId,
}
```

## `submissions/{id}`
```
{
  assignmentId, studentId,
  submittedAt: timestamp,
  fileUrl: string,
  grade?: number,
  feedback?: string,
}
```

## `leaveRequests/{id}`
```
{
  studentId, studentName,
  from: timestamp, to: timestamp,
  reason: string,
  status: 'pending' | 'approved' | 'rejected',
  reviewedBy?: uid,
  schoolId,
}
```

## `events/{id}`
```
{
  title, description,
  date: timestamp,
  schoolId,
}
```

## `chats/{chatId}`
```
{ participants: uid[], lastMessage: string, updatedAt: timestamp }

chats/{chatId}/messages/{msgId} : {
  fromId, fromName, toId, body, sentAt: timestamp
}
```

## Required composite indexes

- `attendance`: `classId ASC`, `date DESC`
- `attendance`: `studentId ASC`, `date DESC`
- `marks`: `studentId ASC`, `uploadedAt DESC`
- `marks`: `classId ASC`, `subjectId ASC`, `examName ASC`
- `fees`: `studentId ASC`, `dueDate ASC`
- `announcements`: `schoolId ASC`, `createdAt DESC`
- `assignments`: `classId ASC`, `dueDate ASC`
- `leaveRequests`: `status ASC`, `from DESC`
