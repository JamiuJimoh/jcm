import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/list_items_builder.dart';
import 'package:jamiu_class_manager/app/home/models/classroom.dart';
import 'package:jamiu_class_manager/common_widgets/user_circle_avatar.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'edit_classroom_convo_page.dart';
import '../share_with_class_container.dart';

class ClassroomWidget extends StatelessWidget {
  ClassroomWidget({required this.courseID});
  final String courseID;

  static Widget create(context, {required String courseID}) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<Database>(
      create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
      child: ClassroomWidget(courseID: courseID),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        children: [
          ShareWithClassContainer(
            borderColor: Theme.of(context).primaryColor,
            child: Row(
              children: [
                UserCircleAvatar(),
                const SizedBox(width: 15.0),
                Text(
                  'Share with the class...',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 14.0),
                ),
              ],
            ),
            onPressed: () =>
                EditClassroomConvoPage.show(context, courseID: courseID),
          ),
          ..._buildDivider(),
          Expanded(
            child: StreamBuilder<List<Classroom>>(
              stream: database.classroomStream(),
              builder: (context, snapshot) {
                return ListItemsBuilder<Classroom>(
                  snapshot: snapshot,
                  itemBuilder: (_, classroom) => Text(classroom.message),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDivider() {
    return [
      const SizedBox(height: 10.0),
      const Divider(
        thickness: 0.7,
      ),
      const SizedBox(height: 10.0),
    ];
  }
}
