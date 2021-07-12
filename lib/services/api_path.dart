class APIPath {
  static String userType({required String uid, required String userTypeId}) =>
      'users/$uid/userTypes/$userTypeId';

  static String userTypes({required String uid}) =>
      'users/$uid/userTypes';
  // static String users({required String uid}) => 'users/$uid';
}
