// import 'package:jamiu_class_manager/app/home/models/course.dart';
// import 'package:jamiu_class_manager/app/home/models/joined_course.dart';
// import 'package:jamiu_class_manager/app/home/models/user_profile.dart';
// import 'package:jamiu_class_manager/services/database.dart';

// import 'package:collection/collection.dart';

// class PeopleBloc {
//   PeopleBloc({required this.database});
//   final Database database;

//   Stream<List<UserProfile>> userClassroomStreamCombiner(String teacherId) =>
//       Rx.combineLatest2(
//         database.coursesStream(false),
//         database.joinedCoursesStream(),
//         _classroomStreamCombiner,
//       );

//   // static List<UserProfile> _classroomStreamCombiner(
//   //     List<Course> course, List<JoinedCourse> joinedCourses) {
//   //   return course.map((course) {
//   //     final foundStudents = joinedCourses.firstWhereOrNull(
//   //         (joinedCourse) => course.courseId == joinedCourse.courseId);
//   //     return UserProfile(
//   //       userID: foundStudents. userID,
//   //       name: foundStudents. name,
//   //       surname: foundStudents. surname,
//   //       email: foundStudents. email,
//   //       imageUrl: foundStudents. imageUrl,
//   //     );
//   //   }).toList();
//   // }

//   static List<
  
// }