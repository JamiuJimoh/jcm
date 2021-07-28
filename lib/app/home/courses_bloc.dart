import 'dart:async';

import 'package:flutter/services.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'models/course.dart';

class CoursesBloc {
  final Database database;
  final AuthBase auth;

  CoursesBloc({required this.database, required this.auth});

  final _isErrorController = BehaviorSubject<bool>();

  StreamSink<bool> get isErrorSink => _isErrorController.sink;
  Stream<bool> get isErrorStream => _isErrorController.stream;

  void dispose() {
    _isErrorController.close();
  }

  // StreamSink<Course> get courseSink => _courseController.sink;
  // Stream<Course> get courseStream => _courseController.stream;

  Future<void> joinCourse(String courseIV) async {
    //   final course = database.coursesStream().transform(
    //     StreamTransformer<List<Course>, Course>.fromHandlers(
    //       handleData: (courses, courseSink) {
    //         final joinedCourse =
    //             courses.firstWhereOrNull((course) => course.courseIV == courseIV);
    //         if (joinedCourse == null) {
    //           courseSink.addError('No items matched');
    //           return null;
    //         } else {
    //           courseSink.add(joinedCourse);
    //         }
    //       },
    //     ),
    //   ).handleError((error) {
    //     print(error);
    //   });
    //   course.first.then((course) => database.joinCourse(course));
    //   print(course.first.then((value) => print('value===$value')));
    // final course = database.coursesStream().listen((courses) {
    //   final foundJoinedCourse =
    //       courses.firstWhereOrNull((course) => course.courseIV == courseIV);
    //   print(foundJoinedCourse);
    // }, onError: (error) {
    //   print(error);
    // });
    // final course = database.coursesStream().firstWhere(
    //       (course) => course.first.courseIV == courseIV,
    //       orElse: null,
    //     );
    // final c = await course.then((cours) => cours.first, onError: (e) {
    //   print(e);
    // });
    // database.joinCourse(c);
    // print(c);
    database.coursesStream().listen((event) {
      final foundCourse = event.firstWhereOrNull(
        (course) =>
            course.courseIV == courseIV &&
            course.teacherId != auth.currentUser?.uid,
      );
      if (foundCourse == null) {
        isErrorSink.add(true);
      } else {
        database.joinCourse(foundCourse);
        isErrorSink.add(false);
      }
    });
    // return _error;
  }
}
