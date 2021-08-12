class UserProfile {
  UserProfile({
    required this.userID,
    required this.name,
    required this.surname,
    required this.email,
    required this.imageUrl,
  });
  final String userID;
  final String name;
  final String surname;
  final String email;
  final String imageUrl;

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final String surname = data['surname'];
    final String email = data['email'];
    final String imageUrl = data['imageUrl'];

    return UserProfile(
      userID: documentId,
      name: name,
      surname: surname,
      email: email,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'surname': surname,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return '{userID: $userID, name: $name, surname: $surname, email: $email, imageUrl: $imageUrl,}';
  }
}
