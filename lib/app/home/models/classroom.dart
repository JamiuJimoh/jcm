class Classroom {
  Classroom({required this.classroomID, required this.message, required this.courseID});
  final String classroomID;
  final String message;
  final String courseID;

  factory Classroom.fromMap(Map<String, dynamic> data, String documentId) {
    final String courseID = data['courseID'];
    final String message = data['message'];

    return Classroom(
      classroomID: documentId,
      message: message,
      courseID: courseID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomID': classroomID,
      'message': message,
      'courseID': courseID,
    };
  }
}
