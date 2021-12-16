import 'package:flutter/material.dart';

import '../models/created_course.dart';
import '../models/joined_course.dart';
import 'classroom_tab/classroom_widget.dart';
import 'classwork_tab/classwork.dart';
import 'people.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({
    Key? key,
    this.joinedCourse,
    this.createdCourse,
  }) : super(key: key);
  final JoinedCourse? joinedCourse;
  final CreatedCourse? createdCourse;

  static Future<void> show(
    BuildContext context, {
    JoinedCourse? joinedCourse,
    CreatedCourse? createdCourse,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CoursePage(
          joinedCourse: joinedCourse,
          createdCourse: createdCourse,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text((createdCourse?.courseTitle ?? joinedCourse?.courseTitle)!),
          // toolbarHeight: 150.0,
          bottom:const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.forum), text: 'Classroom'),
              Tab(icon: Icon(Icons.description_outlined), text: 'Classwork'),
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'People'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ClassroomWidget.create(
              context,
              courseID: joinedCourse?.courseId == null
                  ? createdCourse!.courseId
                  : joinedCourse!.courseId,
            ),
            Classwork.create(context),
            People(),
          ],
        ),
      ),
    );
  }
}
