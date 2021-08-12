import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    print('path===$path, data===$data');
    await documentReference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required String uid,
    required bool isCreatedCourseCollectionStream,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final ref = isCreatedCourseCollectionStream
        ? FirebaseFirestore.instance
            .collection(path)
            .where('teacherId', isEqualTo: uid)
        : FirebaseFirestore.instance.collection(path);
    final snapshot = ref.snapshots();

    return snapshot.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<List<T>> classroomCollectionStream<T>({
    required String path,
    required String uid,
    required String courseID,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final ref = FirebaseFirestore.instance
        .collection(path)
        .where('courseID', isEqualTo: courseID);
    final snapshot = ref.snapshots();

    return snapshot.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete $path');
    await reference.delete();
  }
}
