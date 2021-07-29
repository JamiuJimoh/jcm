import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';

class CourseChangeNotifier with ChangeNotifier {
  var _isError = false;

  bool get isError => _isError;

  set setIsError(bool isError) {
    _isError = isError;
    notifyListeners();
  }

  Future<void> joinCourse({
    required String courseIV,
    required Database database,
    required AuthBase auth,
  }) async {
    database.coursesStream(false).listen((event) {
      final foundCourse = event.firstWhereOrNull((course) {
        return course.courseIV == courseIV &&
            course.teacherId != auth.currentUser?.uid;
      });
      if (foundCourse == null) {
        setIsError = true;
      } else {
        database.joinCourse(foundCourse);
        setIsError = false;
      }
    });
  }
}
