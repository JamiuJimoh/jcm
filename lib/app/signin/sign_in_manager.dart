import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  SignInManager({required this.auth, required this.isLoading});

  // final StreamController<bool> _isLoadingController = StreamController<bool>();
  // Stream<bool> get isLoadingStream => _isLoadingController.stream;

  // void dispose() {
  //   _isLoadingController.close();
  // }

  // void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      // _setIsLoading(true);
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      // _setIsLoading(false);
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
}
