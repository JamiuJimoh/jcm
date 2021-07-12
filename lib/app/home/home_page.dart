import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/models/user.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'course_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.database});
  final Database database;

  static Widget create({required String uid}) {
    return Provider<Database>(
      create: (_) => FireStoreDatabase(uid: uid),
      child: Consumer<Database>(
        builder: (_, database, __) => HomePage(database: database),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<List<UserModel>>(
            stream: database.usersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Text(snapshot.data!.first.userType);
                } else {
                  return Text('Courses');
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
        actions: [
          Consumer<AuthBase>(
            builder: (_, auth, __) => IconButton(
              onPressed: auth.signOut,
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('add course');
          final userType = UserModel(
            userType: 'Teachers',
          );
          database.setUserType(userType);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
