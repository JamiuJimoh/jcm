import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/models/course.dart';

import '../models/created_course.dart';
import '../models/joined_course.dart';
import 'classroom_tab/classroom_widget.dart';
import 'classwork_tab/classwork.dart';
import 'people_tab/people.dart';

enum EntityType { instructor, student }

class CoursePage extends StatefulWidget {
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
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late final EntityType entityType;
  late final Course course;

  final _tabs = const [
    Tab(icon: Icon(Icons.forum), text: 'Classroom'),
    Tab(icon: Icon(Icons.description_outlined), text: 'Classwork'),
    Tab(icon: Icon(Icons.people_alt_outlined), text: 'People'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.createdCourse == null) {
      entityType = EntityType.student;
    } else {
      entityType = EntityType.instructor;
    }

    if (entityType == EntityType.instructor) {
      course = widget.createdCourse as Course;
    } else {
      course = widget.joinedCourse as Course;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.courseTitle),
          // toolbarHeight: 150.0,
          bottom: TabBar(
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: [
            ClassroomWidget.create(context, courseID: course.courseId),
            Classwork.create(context,
                courseID: course.courseId, entityType: entityType),
            People.create(context, course: course),
          ],
        ),
      ),
    );
  }
}
