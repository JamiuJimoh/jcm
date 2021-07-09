abstract class StringValidator {
  bool isValid(String value);
  bool isValidPassword(String value);
  bool confirmPasswordMatch(String password, String confirmPassword);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  @override
  bool isValidPassword(String value) {
    return value.length >= 7;
  }

  @override
  bool confirmPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}

mixin EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final StringValidator confirmPasswordValidator = NonEmptyStringValidator();

  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Must be at least 7 characters long';
  final String invalidConfirmPasswordErrorText = 'Password must match ';
}
