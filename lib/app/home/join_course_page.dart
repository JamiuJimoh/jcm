import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/common_widgets/user_circle_avatar.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'models/created_course.dart';
import 'validators.dart';

class JoinCoursePage extends StatefulWidget with CourseValidators {
  final Database database;
  final AuthBase auth;

  JoinCoursePage({
    required this.database,
    required this.auth,
  });

  static Future<void> create(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JoinCoursePage(database: database, auth: auth),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _JoinCoursePageState createState() => _JoinCoursePageState();
}

class _JoinCoursePageState extends State<JoinCoursePage> {
  final _textController = TextEditingController();

  User get user => widget.auth.currentUser!;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  Future<void> _submit(List<CreatedCourse> createdCourses) async {
    try {
      final courseIV = _textController.text;
      final foundCourse = createdCourses.firstWhereOrNull((course) {
        return course.courseIV == courseIV &&
            course.teacherId != widget.auth.currentUser?.uid;
      });

      if (foundCourse == null) {
        showExceptionAlertDialog(
          context,
          title: 'Course not found',
          exception: Exception('No course matches your course IV'),
          defaultActionText: 'Dismiss',
        );
      } else {
        widget.database.joinCourse(foundCourse);
        Navigator.of(context).pop();
      }
    } on FireStoreDatabase catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Course not found',
        exception: Exception(e),
        defaultActionText: 'Dismiss',
      );
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join course'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<CreatedCourse>>(
      stream: widget.database.coursesStream(false),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final createdCourses = snapshot.data!;
          if (createdCourses.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Currently Signed in as',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontSize: 15.0,
                              // fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 17.0),
                      ListTile(
                        leading: UserCircleAvatar(),
                        title: Text(user.displayName ?? 'User'),
                        subtitle: Text(user.email!),
                      ),
                      const SizedBox(height: 15.0),
                      const Divider(
                        thickness: 0.8,
                      ),
                      const SizedBox(height: 19.0),
                      Text(
                        'Ask your teacher for the Course IV, then enter it here.',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 15.0, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 15.0),
                      CustomTextFormField(
                        // initialValue: _initialValue['courseCode'],
                        controller: _textController,
                        labelText: 'Course IV',
                        hintText: 'e.g NJ6kEDU312',
                        // errorText: 'Insert courseIV',
                        // enabled: false,
                        validator: (value) =>
                            widget.courseIVValidator.isValid(value!)
                                ? null
                                : widget.invalidCourseIVErrorText,
                      ),
                      const SizedBox(height: 15.0),
                      CustomElevatedButton(
                        child: Text('JOIN COURSE'),
                        height: 50.0,
                        onPressed: () => _submit(createdCourses),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          print(snapshot.error);
          showExceptionAlertDialog(
            context,
            title: 'Course not found',
            exception: Exception('No course matches your course IV'),
            defaultActionText: 'Dismiss',
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
