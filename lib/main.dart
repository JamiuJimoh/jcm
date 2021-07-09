import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

import 'app/signin/sign_in_page.dart';
import 'app_theme.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create:(_)=>Auth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightMode,
        home: SignInPage(),
      ),
    );
  }
}
