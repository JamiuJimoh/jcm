import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_container.dart';

class CourseContainer extends CustomContainer {
  CourseContainer({
    required Widget courseCode,
    required Widget courseTitle,
    required Widget teacherName,
    required VoidCallback onPressed,
  }) : super(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              courseCode,
              const SizedBox(height: 5.0),
              courseTitle,
              const Spacer(),
              teacherName,
            ],
          ),
          // borderColor: Colors.red,
          gradient: LinearGradient(
            colors: [
              Colors.indigo,
              Colors.deepPurple,
            ],
          ),
          height: 160.0,
          onPressed: onPressed,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        );
}
