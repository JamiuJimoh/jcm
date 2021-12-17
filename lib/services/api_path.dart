class APIPath {
  static String course(String courseId) => '/courses/$courseId';

  static String courses() => '/courses';

  static String courseConvo(String classroomId) => '/classroom/$classroomId';

  static String courseConvos() => '/classroom';

  static String courseConvoThread(String classroomId, String threadId) =>
      '/classroom/$classroomId/threads/$threadId';

  static String courseConvoThreads(String classroomId) =>
      '/classroom/$classroomId/threads';

  static String joinCourse(String uid, String joinedCourseId) =>
      '/users/$uid/joinedCourses/$joinedCourseId';

  static String joinedCourses(String uid) => '/users/$uid/joinedCourses';

  static String userImage(String uid) => 'userImage/$uid/';

  static String user(String uid) => 'users/$uid/';

  static String users() => 'users/';
}
