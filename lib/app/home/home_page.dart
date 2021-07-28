import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/list_items_builder.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'course_container.dart';
import 'edit_course_page.dart';
import 'join_course_page.dart';
import 'models/course.dart';

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

  Future<void> _buildModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        child: _modalBottomSheetChild(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
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
        onPressed: () => _buildModalBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: StreamBuilder<List<Course>>(
          stream: database.coursesStream(),
          builder: (context, snapshot) {
            return ListItemsBuilder<Course>(
              snapshot: snapshot,
              itemBuilder: (context, course) => CourseContainer(
                courseCode: Text(
                  course.courseCode,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                courseTitle: Text(
                  course.courseTitle,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                teacherName: Text(
                  course.teacherName,
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
            );
          }),
    );
  }

  Widget _modalBottomSheetChild(BuildContext context) {
    return SizedBox(
      height: 130.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                print('Create');
                Navigator.of(context).pop();
                EditCoursePage.show(context);
              },
              child: Text('Create a course', style: TextStyle(fontSize: 16.0)),
            ),
            TextButton(
              onPressed: () {
                print('Join');
                Navigator.of(context).pop();
                JoinCoursePage.create(context);
              },
              child: Text('Join a course', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
