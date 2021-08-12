import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/show_alert_dialog.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/common_widgets/user_circle_avatar.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'course_page/course_page.dart';
import 'models/created_course.dart';
import 'models/joined_course.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({required this.database});
  final Database database;

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Title(
                  color: Colors.black,
                  child: Text(
                    'Jamiu\'s Classroom Manager',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 18.0),
                  ),
                ),
              ),
              ..._buildDivider(),
              _buildProfileHead(context),
              const SizedBox(height: 10.0),
              ..._buildDivider(),
              StreamBuilder<List<CreatedCourse>>(
                stream: database.coursesStream(true),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return snapshot.data!.isEmpty
                        ? Container()
                        : _ExpandableTile(createdCourse: snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  return LinearProgressIndicator();
                },
              ),
              StreamBuilder<List<JoinedCourse>>(
                stream: database.joinedCoursesStream(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return snapshot.data!.isEmpty
                        ? Container()
                        : _ExpandableTile(
                            joinedCourse: snapshot.data!,
                          );
                  }
                  return LinearProgressIndicator();
                },
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    const SizedBox(width: 30.0),
                    Text(
                      'Settings',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<AuthBase>(
                  builder: (_, auth, __) => GestureDetector(
                    onTap: () => _confirmSignOut(context),
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined),
                        const SizedBox(width: 30.0),
                        Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHead(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = auth.currentUser!;
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          UserCircleAvatar(radius: 50.0),
          const SizedBox(height: 15.0),
          Text(
            user.displayName != null
                ? (user.displayName!.isEmpty
                    ? 'USER'
                    : user.displayName!.toUpperCase())
                : 'USER',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 7.0),
          Text(
            user.email ?? 'randomuser@gmailcom',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.w300),
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

////////////////// Expanded List Tile ////////////////

class _ExpandableTile extends StatefulWidget {
  _ExpandableTile({
    this.createdCourse,
    this.joinedCourse,
  });
  final List<CreatedCourse>? createdCourse;
  final List<JoinedCourse>? joinedCourse;

  @override
  __ExpandableTileState createState() => __ExpandableTileState();
}

class __ExpandableTileState extends State<_ExpandableTile> {
  var _teachExpanded = false;
  var _enrolledExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.createdCourse != null ? 'Teaching' : 'Enrolled',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              ExpandIcon(
                isExpanded: _teachExpanded,
                onPressed: (_) {
                  setState(() {
                    _teachExpanded = !_teachExpanded;
                    _enrolledExpanded = !_enrolledExpanded;
                  });
                },
              ),
            ],
          ),
          if (_teachExpanded)
            if (widget.createdCourse != null)
              ...widget.createdCourse!
                  .map(
                    (course) => _CourseListTile(
                      courseTitle: course.courseTitle,
                      courseCode: course.courseCode,
                      onTap: () =>
                          CoursePage.show(context, createdCourse: course),
                    ),
                  )
                  .toList(),
          if (_enrolledExpanded)
            if (widget.joinedCourse != null)
              ...widget.joinedCourse!
                  .map(
                    (course) => _CourseListTile(
                      courseTitle: course.courseTitle,
                      courseCode: course.courseCode,
                      onTap: () =>
                          CoursePage.show(context, joinedCourse: course),
                    ),
                  )
                  .toList(),
          ..._buildDivider(),
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

////////////////// Course List Tile ////////////////

class _CourseListTile extends StatelessWidget {
  final String courseTitle;
  final String courseCode;
  final VoidCallback onTap;

  const _CourseListTile({
    required this.courseTitle,
    required this.courseCode,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(),
            title: Text(courseCode, overflow: TextOverflow.ellipsis),
            subtitle: Text(courseTitle, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 5.0),
        ],
      ),
    );
  }
}
