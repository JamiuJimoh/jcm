class Student {
  final String studentId;
  Student({
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
    };
  }

  factory Student.fromJson(Map<String, dynamic> data) {
    return Student(
      studentId: data['studentId'],
    );
  }
}
