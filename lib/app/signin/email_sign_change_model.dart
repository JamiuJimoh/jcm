import 'package:flutter/foundation.dart';

import 'validators.dart';
import '../../services/auth.dart';

enum EmailSignInFormType { signIn, register }

enum UserType { teacher, student }

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  String confirmPassword;
  EmailSignInFormType formType;
  UserType? userType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  EmailSignInChangeModel({
    this.email: '',
    this.password: '',
    this.confirmPassword: '',
    this.formType: EmailSignInFormType.signIn,
    this.userType,
    this.isLoading: false,
    this.submitted: false,
    required this.auth,
  });

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    updateWith(submitted: true, isLoading: true);

    try {
      await auth.signInWithGoogle();
    } catch (e) {
      updateWith(isLoading: false);

      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryButtonText {
    final signInText = 'Don\'t have an account? Register';
    final registerText = 'Already have an account? Sign In';
    return formType == EmailSignInFormType.signIn ? signInText : registerText;
  }

  bool get canSubmit {
    if (formType == EmailSignInFormType.signIn) {
      return emailValidator.isValid(email) &&
          passwordValidator.isValid(password) &&
          !isLoading;
    } else {
      return emailValidator.isValid(email) &&
          passwordValidator.isValid(password) &&
          confirmPasswordValidator.confirmPasswordMatch(
            password,
            confirmPassword,
          ) &&
          // userType != null &&
          !isLoading;
    }
  }

  String? get emailErrorText {
    var showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String? get passwordErrorText {
    var showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get confirmPasswordErrorText {
    var showErrorText = submitted &&
        !confirmPasswordValidator.confirmPasswordMatch(
          password,
          confirmPassword,
        );
    return showErrorText ? invalidConfirmPasswordErrorText : null;
  }

  String? get userErrorText {
    var showErrorText = submitted && userType == null;
    return showErrorText ? 'Register as a teacher or student' : null;
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void pickUserType(UserType type) {
    final userType = type;

    updateWith(
      email: '',
      password: '',
      userType: userType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateConfirmPassword(String confirmPassword) =>
      updateWith(confirmPassword: confirmPassword);

  void updateWith({
    String? email,
    String? password,
    String? confirmPassword,
    EmailSignInFormType? formType,
    UserType? userType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.formType = formType ?? this.formType;
    this.userType = userType ?? this.userType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;

    notifyListeners();
  }
}
