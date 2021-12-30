import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }

  Future<String> setFile({
    required String path,
    required String fileID,
    required File file,
  }) async {
    final documentReference = FirebaseStorage.instance
        .ref()
        .child(path)
        .child(fileID)
        .child(file.path);

    await documentReference.putFile(file);
    return documentReference.getDownloadURL();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required String uid,
    bool isCreatedCourseCollectionStream = false,
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

  Stream<List<T>> pdfStream<T>({
    required String path,
    required String itemID,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final ref = FirebaseFirestore.instance
        .collection(path)
        .where('classworkItemID', isEqualTo: itemID);
    final snapshot = ref.snapshots();

    return snapshot.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<List<T>> userCollectionStream<T>({
    required String path,
    required String uid,
    bool? isCurrentUser = false,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final ref = isCurrentUser!
        ? FirebaseFirestore.instance
            .collection(path)
            .where('userID', isEqualTo: uid)
        : FirebaseFirestore.instance.collection(path);
    final snapshot = ref.snapshots();

    return snapshot.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<List<T>> entitiesCollectionStream<T>({
    required String path,
    required String teacherId,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final ref = FirebaseFirestore.instance
        .collection(path)
        .where('userID', isEqualTo: teacherId);
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
    await FirebaseFirestore.instance.doc(path).delete();
  }

  Future<void> deleteFile({required String url}) async {
    final ref = FirebaseStorage.instance.refFromURL(url);
    await ref.delete();
  }
}
