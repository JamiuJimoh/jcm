class APIPath {
  static String course( String courseId) =>
      '/courses/$courseId';

  static String courses() => '/courses';

  static String joinCourse(String uid, String joinedCourseId) =>
      '/users/$uid/joinedCourses/$joinedCourseId';

  static String joinedCourses(String uid) => '/users/$uid/joinedCourses';

  static String userType({required String uid, required String userTypeId}) =>
      'users/$uid/userTypes/$userTypeId';

  static String userTypes({required String uid}) => 'users/$uid/userTypes';
}
