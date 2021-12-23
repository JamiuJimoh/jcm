import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import 'models/created_course.dart';
import 'models/joined_course.dart';
import 'models/user_profile.dart';

class CoursesBloc {
  CoursesBloc({required this.database, required this.auth});
  final Database database;
  final AuthBase auth;

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
