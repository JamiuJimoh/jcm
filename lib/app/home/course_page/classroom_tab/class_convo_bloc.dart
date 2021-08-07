import 'package:jamiu_class_manager/app/home/models/created_course.dart';
import 'package:jamiu_class_manager/app/home/models/joined_course.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class ClassConvoBloc {
  ClassConvoBloc({required this.database});
  final Database database;

  void get allCoursesStream => Rx.combineLatest2(
        database.joinedCoursesStream(),
        database.coursesStream(false),
        _entriesJobsCombiner,
      );

  static void _entriesJobsCombiner(
      List<JoinedCourse> joinedCourses, List<CreatedCourse> createdCourses) {
    final courses = createdCourses.map((createdCourse) {
      return joinedCourses.firstWhereOrNull(
          (joinedCourse) => joinedCourse.courseId == createdCourse.courseId);
    }).toList();
  }
}
