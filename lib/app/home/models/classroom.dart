class Classroom {
  Classroom({
    required this.classroomID,
    required this.message,
    required this.courseID,
    required this.sender,
    required this.time,
  });
  final String classroomID;
  final String message;
  final String courseID;
  final String sender;
  final String time;

  factory Classroom.fromMap(Map<String, dynamic> data, String documentId) {
    final String courseID = data['courseID'];
    final String message = data['message'];
    final String sender = data['sender'];
    final String time = data['time'];

    return Classroom(
      classroomID: documentId,
      message: message,
      courseID: courseID,
      sender: sender,
      time: time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomID': classroomID,
      'message': message,
      'courseID': courseID,
      'sender': sender,
      'time': time,
    };
  }
}
