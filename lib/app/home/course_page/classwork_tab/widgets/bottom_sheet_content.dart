import 'package:flutter/material.dart';

import '../course_materials/edit_assignment_page.dart';
import '../course_materials/edit_material_page.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({
    Key? key,
    required this.courseId,
  }) : super(key: key);
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create',
            style: TextStyle(fontSize: 22.0),
          ),
          const SizedBox(height: 5.0),
          Column(
            children: [
              ListTile(
                horizontalTitleGap: 0.0,
                leading:
                    const Icon(Icons.class__outlined, color: Colors.black54),
                title: const Text('Material'),
                onTap: () {
                  Navigator.of(context).pop();
                  EditMaterialPage.show(context, courseId: courseId);
                },
              ),
              ListTile(
                horizontalTitleGap: 0.0,
                leading: const Icon(Icons.assignment_outlined,
                    color: Colors.black54),
                title: const Text('Assignment'),
                onTap: () {
                  Navigator.of(context).pop();
                  EditAssignmentPage.show(context, courseId: courseId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
