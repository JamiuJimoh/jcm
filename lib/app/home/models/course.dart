class Course {
  final String courseId;
  final String teacherId;
  final String courseTitle;
  final String courseCode;
  final String teacherName;

  Course({
    required this.courseId,
    required this.teacherId,
    required this.courseTitle,
    required this.courseCode,
    required this.teacherName,
  });

  factory Course.fromMap(Map<String, dynamic> data, String documentId) {
    final String teacherId = data['teacherId'];
    final String courseTitle = data['courseTitle'];
    final String courseCode = data['courseCode'];
    final String teacherName = data['teacherName'];

    return Course(
      courseId: documentId,
      teacherId: teacherId,
      courseTitle: courseTitle,
      courseCode: courseCode,
      teacherName: teacherName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'teacherId': teacherId,
      'courseTitle': courseTitle,
      'courseCode': courseCode,
      'teacherName': teacherName,
    };
  }

  @override
  String toString() {
    return 'courseTitle: $courseTitle, courseCode: $courseCode';
  }
}
