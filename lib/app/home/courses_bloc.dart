import 'dart:async';

import 'package:jamiu_class_manager/app/home/models/user_profile.dart';
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

  Stream<List<JoinedCourse>> get joinedCourseStreamCombiner =>
      Rx.combineLatest2(
        database.joinedCoursesStream(),
        database.userProfilesStream(),
        _joinedCourseStreamCombiner,
      );

  static List<JoinedCourse> _joinedCourseStreamCombiner(
      List<JoinedCourse> joinedCourses, List<UserProfile> userProfiles) {
    return joinedCourses.map((course) {
      final foundTeacher = userProfiles
          .firstWhereOrNull((user) => course.teacherId == user.userID);
      return JoinedCourse(
        courseId: course.courseId,
        courseIV: course.courseIV,
        teacherId: course.teacherId,
        courseTitle: course.courseTitle,
        courseCode: course.courseCode,
        teacherName: '${foundTeacher?.name} ${foundTeacher?.surname}',
      );
    }).toList();
  }

  Stream<List<CreatedCourse>> get createdCourseStreamCombiner =>
      Rx.combineLatest2(
        database.coursesStream(true),
        database.userProfilesStream(),
        _createdCourseStreamCombiner,
      );

  static List<CreatedCourse> _createdCourseStreamCombiner(
      List<CreatedCourse> createdCourses, List<UserProfile> userProfiles) {
    return createdCourses.map((course) {
      final foundTeacher = userProfiles
          .firstWhereOrNull((user) => course.teacherId == user.userID);
      return CreatedCourse(
        courseId: course.courseId,
        courseIV: course.courseIV,
        teacherId: course.teacherId,
        courseTitle: course.courseTitle,
        courseCode: course.courseCode,
        teacherName: '${foundTeacher?.name} ${foundTeacher?.surname}',
      );
    }).toList();
  }
}
