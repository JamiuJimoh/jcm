import 'package:flutter/material.dart';

import '../models/created_course.dart';
import '../models/joined_course.dart';
import 'classroom.dart';
import 'classwork.dart';
import 'people.dart';

class CoursePage extends StatelessWidget {
  CoursePage({this.joinedCourse, this.createdCourse});
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

  final List<Widget> _pages = [Classroom(), Classwork(), People()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _pages.length,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text((createdCourse?.courseTitle ?? joinedCourse?.courseTitle)!),
          // toolbarHeight: 150.0,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.forum), text: 'Classroom'),
              Tab(icon: Icon(Icons.description_outlined), text: 'Classwork'),
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'People'),
            ],
          ),
        ),
      ),
    );
  }
}
