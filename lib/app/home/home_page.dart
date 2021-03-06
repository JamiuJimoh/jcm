import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import 'course_container.dart';
import 'course_page/course_page.dart';
import 'courses_bloc.dart';
import 'edit_course_page.dart';
import 'join_course_page.dart';
import 'list_items_builder.dart';
import 'menu_drawer.dart';
import 'models/created_course.dart';
import 'models/joined_course.dart';

enum CourseType { joinedCourses, createdCourses }

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final CoursesBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Consumer<Database>(
      builder: (_, database, __) => Provider<CoursesBloc>(
        create: (_) => CoursesBloc(database: database, auth: auth),
        child: Consumer<CoursesBloc>(
          builder: (_, bloc, __) => HomePage(bloc: bloc),
        ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      context: context,
      builder: (_) => SizedBox(
        child: _modalBottomSheetChild(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
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
        child: const Icon(Icons.add),
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
        stream: widget.bloc.createdCourseStreamCombiner,
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
                  onPressed: () =>
                      CoursePage.show(context, createdCourse: course),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          );
        });
  }

  Widget _joinedCourseStreamBuilder() {
    return StreamBuilder<List<JoinedCourse>>(
        stream: widget.bloc.joinedCourseStreamCombiner,
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
                  onPressed: () =>
                      CoursePage.show(context, joinedCourse: course),
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
                Navigator.of(context).pop();
                EditCoursePage.show(context);
              },
              child: const Text('Create a course',
                  style: TextStyle(fontSize: 16.0)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                JoinCoursePage.create(context);
              },
              child:
                  const Text('Join a course', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
