class UserModel {
  final String userType;

  UserModel({required this.userType});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    final String userType = data['userType'];

    return UserModel(userType: userType);
  }

  Map<String, dynamic> toMap() {
    return {
      'userType': userType,
    };
  }
}
