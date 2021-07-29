class CreatedCourse {
  final String courseId;
  final String courseIV;
  final String teacherId;
  final String courseTitle;
  final String courseCode;
  final String teacherName;

  CreatedCourse({
    required this.courseId,
    required this.courseIV,
    required this.teacherId,
    required this.courseTitle,
    required this.courseCode,
    required this.teacherName,
  });

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
