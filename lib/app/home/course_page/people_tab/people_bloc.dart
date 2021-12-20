import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../services/database.dart';
import '../../models/student.dart';
import '../../models/user_profile.dart';

class PeopleBloc {
  PeopleBloc({required this.database});
  final Database database;

  Stream<List<UserProfile>> studentsStreamCombiner(String courseID) =>
      Rx.combineLatest2(
        database.studentsStream(courseID),
        database.userProfilesStream(),
        _peoplesStreamCombiner,
      );

  static List<UserProfile> _peoplesStreamCombiner(
      List<Student> students, List<UserProfile> users) {
    return students.map((student) {
      final foundStudents =
          users.firstWhereOrNull((user) => student.studentId == user.userID);
      return foundStudents!;
    }).toList();
  }
}
