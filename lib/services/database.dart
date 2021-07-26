// import 'api_path.dart';
// import 'firestore_service.dart';

import 'package:jamiu_class_manager/app/home/models/course.dart';
import 'package:jamiu_class_manager/app/home/models/user_model.dart';

import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<Course>> coursesStream();
  Future<void> setCourse(Course course);
  // Future<void> setUserType(UserModel userModel);
  // Stream<List<UserModel>> usersStream();
  // Stream<UserModel> userStream();
//   Stream<List<Meal>> mealsStream();
//   Future<void> deleteMeal(Meal meal);
//   Stream<List<FavoriteMeal>> favoriteMealsStream();
//   Future<void> setFavoriteMeal(FavoriteMeal favoriteMeal);
//   // Future<void> deleteFavoriteMeal(Meal meal);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  final String uid;

  FireStoreDatabase({required this.uid});

  final _service = FirestoreService.instance;

  @override
  Stream<List<Course>> coursesStream() => _service.collectionStream<Course>(
        path: APIPath.courses(uid),
        builder: (data, documentId) => Course.fromMap(data, documentId),
      );

  @override
  Future<void> setCourse(Course course) => _service.setData(
        path: APIPath.course(uid, course.courseId),
        data: course.toMap(),
      );

  // @override
  // Stream<List<UserModel>> usersStream() => _service.collectionStream<UserModel>(
  //       path: APIPath.userTypes(uid: uid),
  //       builder: (data, documentId) => UserModel.fromMap(data),
  //     );

  // @override
  // Future<void> setUserType(UserModel userModel) {
  //   return _service.setData(
  //     path: APIPath.userType(uid: uid, userTypeId: uid),
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
//         path: APIPath.favoriteMeals(uid: uid),
//         builder: (data, documentId) => FavoriteMeal.fromMap(data, documentId),
//       );

//   @override
//   Future<void> setFavoriteMeal(FavoriteMeal favoriteMeal) => _service.setData(
//         path: APIPath.favoriteMeal(uid: uid, mealId: favoriteMeal.mealId),
//         data: favoriteMeal.toMap(),
//       );

//   // @override
//   // Future<void> deleteFavoriteMeal(Meal meal) => _service.deleteData(
//   //       path: APIPath.favoriteMeal(uid: uid, mealId: meal.mealId),
//   //     );
}
