import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/list_items_builder.dart';
import 'package:jamiu_class_manager/app/home/models/created_course.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'course_container.dart';
import 'edit_course_page.dart';
import 'join_course_page.dart';
import 'menu_drawer.dart';
import 'models/joined_course.dart';

enum CourseType { joinedCourses, createdCourses }

class HomePage extends StatefulWidget {
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _courseType = CourseType.joinedCourses;

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
      drawer: MenuDrawer(database: widget.database),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _courseType == CourseType.joinedCourses ? 'Enrolled' : 'Teaching',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Theme.of(context).secondaryHeaderColor),
        ),
        actions: [
          PopupMenuButton<CourseType>(
            color: Theme.of(context).primaryColor,
            initialValue: _courseType,
            onSelected: (courseType) {
              setState(() {
                _courseType = courseType;
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(
                    'Joined Courses',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: Colors.white),
                  ),
                  value: CourseType.joinedCourses,

                  // value: ,
                ),
                PopupMenuItem(
                  child: Text('Created Courses',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white)),
                  value: CourseType.createdCourses,
                  // value: ,
                ),
              ];
            },
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
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: _courseType == CourseType.joinedCourses
          ? _joinedCourseStreamBuilder()
          : _createdCourseStreamBuilder(),
    );
  }

  Widget _createdCourseStreamBuilder() {
    return StreamBuilder<List<CreatedCourse>>(
        stream: widget.database.coursesStream(true),
        builder: (context, snapshot) {
          return ListItemsBuilder<CreatedCourse>(
            emptyStateMessage: 'Tap the button below to create a class',
            snapshot: snapshot,
            itemBuilder: (context, course) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CourseContainer(
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
                const SizedBox(height: 10.0),
              ],
            ),
          );
        });
  }

  Widget _joinedCourseStreamBuilder() {
    return StreamBuilder<List<JoinedCourse>>(
        stream: widget.database.joinedCoursesStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<JoinedCourse>(
            emptyStateMessage: 'Tap the button below to join a class',
            snapshot: snapshot,
            itemBuilder: (context, course) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CourseContainer(
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
                const SizedBox(height: 10.0),
              ],
            ),
          );
        });
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
