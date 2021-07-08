import 'package:flutter/material.dart';

import 'app/signin/sign_in_page.dart';
import 'app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightMode,
      home: SignInPage(),
    );
  }
}
