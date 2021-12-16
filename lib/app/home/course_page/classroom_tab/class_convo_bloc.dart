import 'package:collection/collection.dart';
import '../../models/classroom_convo_thread.dart';
import '../../models/user_thread.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../services/database.dart';
import '../../models/classroom.dart';
import '../../models/user_classroom.dart';
import '../../models/user_profile.dart';

class ClassConvoBloc {
  ClassConvoBloc({required this.database});
  final Database database;

  Stream<List<UserClassroom>> userClassroomStreamCombiner(String courseID) =>
      Rx.combineLatest2(
        database.classroomStream(courseID),
        database.userProfilesStream(),
        _classroomStreamCombiner,
      );

  static List<UserClassroom> _classroomStreamCombiner(
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

   Stream<List<UserThread>> userThreadStreamCombiner(String classroomID) =>
      Rx.combineLatest2(
        database.classroomConvoThreadStream(classroomID),
        database.userProfilesStream(),
        _threadStreamCombiner,
      );

      
  static List<UserThread> _threadStreamCombiner(
      List<ClassroomConvoThread> threads, List<UserProfile> userProfiles) {
    return threads.map((thread) {
      final foundSender = userProfiles
          .firstWhereOrNull((user) => thread.senderID == user.userID);
      return UserThread(
        thread: thread,
        userProfile: foundSender,
      );
    }).toList();
  }
// database.classroomConvoThreadStream(
//                         userClassroom.classroom.classroomID),
}
