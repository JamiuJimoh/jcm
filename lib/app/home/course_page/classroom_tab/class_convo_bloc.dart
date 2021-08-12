import 'package:jamiu_class_manager/app/home/models/classroom.dart';
import 'package:jamiu_class_manager/app/home/models/created_course.dart';
import 'package:jamiu_class_manager/app/home/models/joined_course.dart';
import 'package:jamiu_class_manager/app/home/models/user_classroom.dart';
import 'package:jamiu_class_manager/app/home/models/user_profile.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class ClassConvoBloc {
  ClassConvoBloc({required this.database});
  final Database database;

  Stream<List<UserClassroom>> userClassroomStreamCombiner(String courseID) =>
      Rx.combineLatest2(
        database.classroomStream(courseID),
        database.userProfilesStream(),
        _streamCombiner,
      );

  static List<UserClassroom> _streamCombiner(
      List<Classroom> classrooms, List<UserProfile> userProfiles) {
    return classrooms.map((classroom) {
      final foundSender = userProfiles
          .firstWhereOrNull((user) => classroom.senderID == user.userID);
      return UserClassroom(
        classroom: classroom,
        userProfile: foundSender,
      );
    }).toList();
  }
}
