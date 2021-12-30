import 'package:cloud_firestore/cloud_firestore.dart';

class CourseAssignment {
  final String assignmentId;
  final Timestamp postedAt;
  final Timestamp dueDate;
  final int points;
  final String title;
  final String description;
  CourseAssignment({
    required this.assignmentId,
    required this.postedAt,
    required this.dueDate,
    required this.points,
    required this.title,
    required this.description,
  });

  factory CourseAssignment.fromJson(Map<String, dynamic> data) {
    return CourseAssignment(
      assignmentId: data['assignmentId'],
      postedAt: data['postedAt'],
      title: data['title'],
      description: data['description'],
      dueDate: data['dueDate'],
      points: data['points'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assignmentId': assignmentId,
      'postedAt': postedAt,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'points': points,
    };
  }
}
