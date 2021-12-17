import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/join_course_page.dart';
import 'package:jamiu_class_manager/app/home/models/course.dart';
import 'package:jamiu_class_manager/app/home/models/joined_course.dart';
import 'package:jamiu_class_manager/app/home/models/user_profile.dart';
import 'package:jamiu_class_manager/common_widgets/user_circle_avatar.dart';
import 'package:provider/provider.dart';

import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../list_items_builder.dart';

class People extends StatelessWidget {
  const People({
    Key? key,
    required this.course,
    required this.database,
  }) : super(key: key);

  final Course course;
  final Database database;

  static Widget create(context, {required Course course}) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<Database>(
      create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
      child: Consumer<Database>(
        builder: (_, database, __) =>
            // ClassroomWidget(courseID: courseID, auth: auth, bloc: bloc),
            People(
          course: course,
          database: database,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 8.0, left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructor',
            style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Theme.of(context).primaryColor, fontSize: 31.0),
          ),
          ..._buildDivider(Theme.of(context).primaryColor),
          StreamBuilder<List<UserProfile>>(
            stream: database.instructorStream(teacherId: course.teacherId),
            builder: (context, snapshot) {
              return ListItemsBuilder<UserProfile>(
                scrollable: false,
                snapshot: snapshot,
                emptyStateTitle: 'Class is empty',
                emptyStateMessage: 'Start class',
                itemBuilder: (_, instructor) => ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  title: Text(
                    '${instructor.name} ${instructor.surname}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 16.0),
                  ),
                  leading: UserCircleAvatar(
                    imageUrl: instructor.imageUrl,
                    radius: 20.0,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 50.0),
          Text(
            course.runtimeType == JoinedCourse ? 'Classmates' : 'Students',
            style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Theme.of(context).primaryColor, fontSize: 31.0),
          ),
          ..._buildDivider(Theme.of(context).primaryColor),
          StreamBuilder<List<UserProfile>>(
            stream: database.instructorStream(teacherId: course.teacherId),
            builder: (context, snapshot) {
              print(snapshot.data);
              return ListItemsBuilder<UserProfile>(
                scrollable: false,
                snapshot: snapshot,
                emptyStateTitle: 'Class is empty',
                emptyStateMessage: 'Start class',
                itemBuilder: (_, instructor) => ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  title: Text(
                    '${instructor.name} ${instructor.surname}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 16.0),
                  ),
                  leading: UserCircleAvatar(
                    imageUrl: instructor.imageUrl,
                    radius: 20.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDivider([Color? color]) {
    return [
      const SizedBox(height: 10.0),
      Divider(
        thickness: 0.7,
        color: color,
      ),
      const SizedBox(height: 20.0),
    ];
  }
}
