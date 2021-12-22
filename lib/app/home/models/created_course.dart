import 'course.dart';

class CreatedCourse extends Course {
  CreatedCourse({
    required String courseId,
    required String courseIV,
    required String teacherId,
    required String courseTitle,
    required String courseCode,
    required String teacherName,
  }) : super(
            courseId: courseId,
            courseIV: courseIV,
            courseCode: courseCode,
            courseTitle: courseTitle,
            teacherId: teacherId,
            teacherName: teacherName);

  factory CreatedCourse.fromMap(Map<String, dynamic> data, String documentId) {
    final String teacherId = data['teacherId'];
    final String courseTitle = data['courseTitle'];
    final String courseCode = data['courseCode'];
    final String courseIV = data['courseIV'];
    final String teacherName = data['teacherName'];

    return CreatedCourse(
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
