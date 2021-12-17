import 'course.dart';

class JoinedCourse extends Course {
  JoinedCourse({
    required String courseId,
    required String courseIV,
    required String teacherId,
    required String courseTitle,
    required String courseCode,
    required String teacherName,
  }) : super(
            courseId: courseId,
            courseIV: courseId,
            courseCode: courseCode,
            courseTitle: courseTitle,
            teacherId: teacherId,
            teacherName: teacherName);

  factory JoinedCourse.fromMap(Map<String, dynamic> data, String documentId) {
    final String teacherId = data['teacherId'];
    final String courseTitle = data['courseTitle'];
    final String courseCode = data['courseCode'];
    final String courseIV = data['courseIV'];
    final String teacherName = data['teacherName'];

    return JoinedCourse(
      courseId: documentId,
      teacherId: teacherId,
      courseTitle: courseTitle,
      courseCode: courseCode,
      courseIV: courseIV,
      teacherName: teacherName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'teacherId': teacherId,
      'courseTitle': courseTitle,
      'courseCode': courseCode,
      'courseIV': courseIV,
      'teacherName': teacherName,
    };
  }

  @override
  String toString() {
    return 'courseTitle: $courseTitle, courseCode: $courseCode, courseIV: $courseIV';
  }
}
