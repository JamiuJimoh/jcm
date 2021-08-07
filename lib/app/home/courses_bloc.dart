import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'models/created_course.dart';
import 'models/joined_course.dart';

class CoursesBloc extends Cubit<bool> {
  CoursesBloc({required this.database, required this.auth}) : super(false);
  // CoursesBloc({required this.database});
  final Database database;
  final AuthBase auth;

  // final AuthBase auth;

  // BehaviorSubject<bool> _isErrorController = BehaviorSubject<bool>();

  // StreamSink<bool> get isErrorSink => _isErrorController.sink;
  // Stream<bool> get isErrorStream => _isErrorController.stream;

  // void dispose() {
  //   _isErrorController.close();
  // }

  void didEmitError() => emit(state);

  Future<void> joinCourse(String courseIV) async {
    database.coursesStream(false).listen((event) {
      final foundCourse = event.firstWhereOrNull(
        (course) =>
            course.courseIV == courseIV &&
            course.teacherId != auth.currentUser?.uid,
      );
      if (foundCourse == null) {
        emit(true);
      } else {
        database.joinCourse(foundCourse);
        emit(false);
      }
    });
  }

  // Stream<List<CreatedCourse>> get createdCourse async{
  //  await database.coursesStream().listen((createdCourses) {
  //     createdCourses.where((course) {
  //       return course.teacherId == auth.currentUser!.uid;
  //     }).toList();
  //   });
  // }
}
