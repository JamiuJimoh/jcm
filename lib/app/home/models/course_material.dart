import 'package:cloud_firestore/cloud_firestore.dart';

class CourseMaterial {
  final String materialId;
  final Timestamp postedAt;
  final String title;
  final String description;
  CourseMaterial({
    required this.materialId,
    required this.postedAt,
    required this.title,
    required this.description,
  });

  factory CourseMaterial.fromJson(Map<String, dynamic> data) {
    return CourseMaterial(
      materialId: data['materialId'],
      postedAt: data['postedAt'],
      title: data['title'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'postedAt': postedAt,
      'title': title,
      'description': description,
    };
  }
}
