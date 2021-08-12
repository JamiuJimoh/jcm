import 'package:cloud_firestore/cloud_firestore.dart';

class Classroom {
  Classroom({
    required this.classroomID,
    required this.message,
    required this.courseID,
    required this.senderID,
    required this.createdAt,
  });
  final String classroomID;
  final String message;
  final String courseID;
  final String senderID;
  final Timestamp createdAt;

  factory Classroom.fromMap(Map<String, dynamic> data, String documentId) {
    final String courseID = data['courseID'];
    final String message = data['message'];
    final String senderID = data['senderID'];
    final Timestamp createdAt = data['createdAt'];

    return Classroom(
      classroomID: documentId,
      message: message,
      courseID: courseID,
      senderID: senderID,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomID': classroomID,
      'message': message,
      'courseID': courseID,
      'senderID': senderID,
      'createdAt': createdAt,
    };
  }
}
