import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../home/models/user_profile.dart';
import 'validators.dart';

enum EmailSignInFormType { signIn, register }

enum UserType { teacher, student }

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  String confirmPassword;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;
  final Database database;

  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    required this.auth,
    required this.database,
  });

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);

    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        final user = await auth.createUserWithEmailAndPassword(email, password);

        await _createUserProfile(user);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    updateWith(isLoading: true);

    try {
      final credential = await auth.signInWithGoogle();
      if (credential.additionalUserInfo!.isNewUser) {
        await _createUserProfile(credential.user);
      }
    } catch (e) {
      updateWith(isLoading: false);

      rethrow;
    }
  }

  Future<void> _createUserProfile(User? firebaseUser) async {
    final user = UserProfile(
      userID: firebaseUser?.uid ?? '',
      name: firebaseUser?.displayName ?? '',
      surname: '',
      email: firebaseUser?.email ?? '',
      imageUrl: firebaseUser?.photoURL ?? '',
    );
    await database.setUserProfile(user, firebaseUser!.uid);
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryButtonText {
    const signInText = 'Don\'t have an account? Register';
    const registerText = 'Already have an account? Sign In';
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
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;

    notifyListeners();
  }
}
