import 'dart:io';

import '../app/home/models/classroom.dart';
import '../app/home/models/classroom_convo_thread.dart';
import '../app/home/models/created_course.dart';
import '../app/home/models/joined_course.dart';
import '../app/home/models/user_profile.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<CreatedCourse>> coursesStream(
      bool isCreatedCourseCollectionStream);
  Future<void> setCourse(CreatedCourse course);
  Future<void> setCourseConvo(Classroom classroom);
  Future<void> setCourseConvoThread(
      String classroomID, ClassroomConvoThread thread);
  Stream<List<ClassroomConvoThread>> classroomConvoThreadStream(
      String classroomID);
  Stream<List<JoinedCourse>> joinedCoursesStream();
  Future<void> joinCourse(CreatedCourse course);
  Stream<List<Classroom>> classroomStream(String courseID);
  Stream<List<UserProfile>> userProfilesStream({bool isCurrentUser = false});
  Future<void> setUserProfile(UserProfile user, String uid);
  Future<String> setImageData(File imageFile);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  final String? uid;

  FireStoreDatabase({required this.uid});

  final _service = FirestoreService.instance;

  @override
  Stream<List<CreatedCourse>> coursesStream(
          bool isCreatedCourseCollectionStream) =>
      _service.collectionStream<CreatedCourse>(
        isCreatedCourseCollectionStream: isCreatedCourseCollectionStream,
        uid: uid!,
        path: APIPath.courses(),
        builder: (data, documentId) => CreatedCourse.fromMap(data, documentId),
      );

  @override
  Future<void> setCourse(CreatedCourse course) => _service.setData(
        path: APIPath.course(course.courseId),
        data: course.toMap(),
      );

  @override
  Future<String> setImageData(File imageFile) => _service.setImageData(
        path: APIPath.userImage(uid!),
        imageFile: imageFile,
      );

  @override
  Stream<List<UserProfile>> userProfilesStream({bool isCurrentUser = false}) =>
      _service.userCollectionStream<UserProfile>(
        isCurrentUser: isCurrentUser,
        uid: uid!,
        path: APIPath.users(),
        builder: (data, documentId) => UserProfile.fromMap(data, documentId),
      );

  @override
  Future<void> setUserProfile(UserProfile user, String uid) => _service.setData(
        path: APIPath.user(uid),
        data: user.toMap(),
      );

  @override
  Future<void> setCourseConvo(Classroom classroom) => _service.setData(
        path: APIPath.courseConvo(classroom.classroomID),
        data: classroom.toMap(),
      );

  @override
  Stream<List<Classroom>> classroomStream(String courseID) =>
      _service.classroomCollectionStream<Classroom>(
        path: APIPath.courseConvos(),
        uid: uid!,
        courseID: courseID,
        builder: (data, documentId) => Classroom.fromMap(data, documentId),
      );

  @override
  Future<void> setCourseConvoThread(
          String classroomID, ClassroomConvoThread thread) =>
      _service.setData(
        path: APIPath.courseConvoThread(classroomID, thread.threadID),
        data: thread.toMap(),
      );

  @override
  Stream<List<ClassroomConvoThread>> classroomConvoThreadStream(
          String classroomID) =>
      _service.collectionStream<ClassroomConvoThread>(
        path: APIPath.courseConvoThreads(classroomID),
        uid: uid!,
        builder: (data, documentId) =>
            ClassroomConvoThread.fromMap(data, documentId),
        isCreatedCourseCollectionStream: false,
      );

  @override
  Stream<List<JoinedCourse>> joinedCoursesStream() =>
      _service.collectionStream<JoinedCourse>(
        isCreatedCourseCollectionStream: false,
        uid: uid!,
        path: APIPath.joinedCourses(uid!),
        builder: (data, documentId) => JoinedCourse.fromMap(data, documentId),
      );

  @override
  Future<void> joinCourse(CreatedCourse course) => _service.setData(
        path: APIPath.joinCourse(uid!, course.courseId),
        data: course.toMap(),
      );

  // @override
  // Stream<List<UserModel>> usersStream() => _service.collectionStream<UserModel>(
  //       path: APIPath.userTypes(uid!: uid!),
  //       builder: (data, documentId) => UserModel.fromMap(data),
  //     );

  // @override
  // Future<void> setUserType(UserModel userModel) {
  //   return _service.setData(
  //     path: APIPath.userType(uid!: uid!, userTypeId: uid!),
  //     data: userModel.toMap(),
  //   );
  // }

//   @override
//   Future<void> deleteMeal(Meal meal) => _service.deleteData(
//         path: APIPath.meal(mealId: meal.mealId),
//       );

//   @override
//   Stream<List<FavoriteMeal>> favoriteMealsStream() =>
//       _service.collectionStream<FavoriteMeal>(
//         path: APIPath.favoriteMeals(uid!: uid!),
//         builder: (data, documentId) => FavoriteMeal.fromMap(data, documentId),
//       );

//   @override
//   Future<void> setFavoriteMeal(FavoriteMeal favoriteMeal) => _service.setData(
//         path: APIPath.favoriteMeal(uid!: uid!, mealId: favoriteMeal.mealId),
//         data: favoriteMeal.toMap(),
//       );

//   // @override
//   // Future<void> deleteFavoriteMeal(Meal meal) => _service.deleteData(
//   //       path: APIPath.favoriteMeal(uid!: uid!, mealId: meal.mealId),
//   //     );
}
