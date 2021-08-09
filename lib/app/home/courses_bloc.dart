import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'models/created_course.dart';
import 'models/joined_course.dart';

class CoursesBloc {
  CoursesBloc({required this.database, required this.auth});
  // CoursesBloc({required this.database});
  final Database database;
  final AuthBase auth;

  final _boolBehaviorSubject = BehaviorSubject<List<bool>>();

  Stream<List<bool>> get boolStream => _boolBehaviorSubject.stream;
  // void addBoolVal() => _boolBehaviorSubject.add(true);
  void dispose() {
    _boolBehaviorSubject.close();
  }

  // final AuthBase auth;

  // BehaviorSubject<bool> _isErrorController = BehaviorSubject<bool>();

  // StreamSink<bool> get isErrorSink => _isErrorController.sink;
  // Stream<bool> get isErrorStream => _isErrorController.stream;

  // void dispose() {
  //   _isErrorController.close();
  // }

  void drainStream() => _boolBehaviorSubject.drain();

  Future<void> joinCourse(String courseIV) async {
    database.coursesStream(false).listen((event) {
      final foundCourse = event.firstWhereOrNull(
        (course) =>
            course.courseIV == courseIV &&
            course.teacherId != auth.currentUser?.uid,
      );
      if (foundCourse == null) {
        _boolBehaviorSubject.add([true]);
      } else {
        database.joinCourse(foundCourse);
        _boolBehaviorSubject.add([false]);
      }
    });
  }

  // void addNull() => _boolBehaviorSubject.add(null);

  // Stream<List<CreatedCourse>> get createdCourse async{
  //  await database.coursesStream().listen((createdCourses) {
  //     createdCourses.where((course) {
  //       return course.teacherId == auth.currentUser!.uid;
  //     }).toList();
  //   });
  // }
}
// class BoolBloc {
//   final _boolBehaviorSubject = BehaviorSubject<bool>();

//   Stream<bool> get boolStream => _boolBehaviorSubject.stream;
//   void addBoolVal() => _boolBehaviorSubject.add(true);
//   void dispose() {
//     _boolBehaviorSubject.close();
//   }
// }