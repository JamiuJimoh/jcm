class APIPath {
  static String course(String uid, String courseId) =>
      '/users/$uid/courses/$courseId';

  static String courses(String uid) => '/users/$uid/courses';

  static String userType({required String uid, required String userTypeId}) =>
      'users/$uid/userTypes/$userTypeId';

  static String userTypes({required String uid}) => 'users/$uid/userTypes';
}
