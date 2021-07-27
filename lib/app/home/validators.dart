abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

mixin CourseValidators {
  final StringValidator courseTitleValidator = NonEmptyStringValidator();
  final StringValidator courseCodeValidator = NonEmptyStringValidator();
  final StringValidator courseIVValidator = NonEmptyStringValidator();

  final String invalidCourseTitleErrorText = 'Course title can\'t be empty';
  final String invalidCourseCodeErrorText = 'Course code can\'t be empty';
  final String invalidCourseIVErrorText = 'Enter a valid courseIV ';
}
