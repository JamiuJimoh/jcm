class APIPath {
  static String course(String courseId) => '/courses/$courseId';

  static String get courses => '/courses';

  static String courseMaterial(String courseId, String materialId) =>
      '/courses/$courseId/materials/$materialId';

  static String courseMaterials(String courseId) =>
      '/courses/$courseId/materials';

  static String student(String courseId, String uid) =>
      '/courses/$courseId/students/$uid';

  static String students(String courseId) => '/courses/$courseId/students';

  static String courseConvo(String classroomId) => '/classroom/$classroomId';

  static String get courseConvos => '/classroom';

  static String courseConvoThread(String classroomId, String threadId) =>
      '/classroom/$classroomId/threads/$threadId';

  static String courseConvoThreads(String classroomId) =>
      '/classroom/$classroomId/threads';

  static String joinCourse(String uid, String joinedCourseId) =>
      '/users/$uid/joinedCourses/$joinedCourseId';

  static String joinedCourses(String uid) => '/users/$uid/joinedCourses';

  static String userImage() => 'userImage/';

  static String pdf(String pdfID) => '/PDFs/$pdfID';

  static String get pdfs => '/PDFs';

  static String user(String uid) => 'users/$uid/';

  static String get users => 'users/';
}
