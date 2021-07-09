import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          Consumer<AuthBase>(
            builder: (_, auth, __) => IconButton(
              onPressed: auth.signOut,
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
