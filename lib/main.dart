import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/home/join_course_page.dart';
import 'app/landing_page.dart';
import 'app_theme.dart';
import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF512DA8),
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightMode,
        home: LandingPage(),
        routes: {
          'join_course_page': (context) => JoinCoursePage(),
        },
      ),
    );
  }
}
