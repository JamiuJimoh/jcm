import 'package:cloud_firestore/cloud_firestore.dart';

class ClassroomConvoThread {
  ClassroomConvoThread({
    required this.threadID,
    required this.message,
    required this.senderID,
    required this.createdAt,
  });
  final String threadID;
  final String message;
  final String senderID;
  final Timestamp createdAt;

  factory ClassroomConvoThread.fromMap(
      Map<String, dynamic> data, String documentId) {
    final String message = data['message'];
    final String senderID = data['senderID'];
    final Timestamp createdAt = data['createdAt'];

    return ClassroomConvoThread(
      threadID: documentId,
      message: message,
      senderID: senderID,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'threadID': threadID,
      'message': message,
      'senderID': senderID,
      'createdAt': createdAt,
    };
  }
}
