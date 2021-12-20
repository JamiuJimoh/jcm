import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:jamiu_class_manager/app/home/models/student.dart';
import 'models/user_profile.dart';

import '../../common_widgets/custom_elevated_button.dart';
import '../../common_widgets/custom_text_form_field.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../common_widgets/user_circle_avatar.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';

import 'models/created_course.dart';
import 'validators.dart';

class JoinCoursePage extends StatefulWidget with CourseValidators {
  final Database database;
  final AuthBase auth;

  JoinCoursePage({Key? key, required this.database, required this.auth})
      : super(key: key);

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
  var _canSubmit = false;
  var _isLoading = false;

  User get user => widget.auth.currentUser!;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  Future<void> _submit(List<CreatedCourse> createdCourses) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final courseIV = _textController.text;
      final foundCourse = createdCourses.firstWhereOrNull((course) {
        return course.courseIV == courseIV &&
            course.teacherId != widget.auth.currentUser?.uid;
      });

      if (foundCourse == null) {
        setState(() {
          _isLoading = false;
        });
        showExceptionAlertDialog(
          context,
          title: 'Course not found',
          exception: Exception('No course matches your course IV'),
          defaultActionText: 'Dismiss',
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        final student = Student(studentId: widget.auth.currentUser!.uid);
        widget.database.joinCourse(foundCourse);
        await widget.database.setStudent(foundCourse, student);
        Navigator.of(context).pop();
      }
    } on FireStoreDatabase catch (e) {
      setState(() {
        _isLoading = false;
      });
      showExceptionAlertDialog(
        context,
        title: 'Course not found',
        exception: Exception(e),
        defaultActionText: 'Dismiss',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join course'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
              _buildUserListTile(),
              const SizedBox(height: 15.0),
              const Divider(
                thickness: 0.8,
              ),
              const SizedBox(height: 19.0),
              Text(
                'Ask your teacher for the Course IV, then enter it here.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 15.0, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 15.0),
              _buildFormStream(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserListTile() {
    return StreamBuilder<List<UserProfile>>(
      stream: widget.database.userProfilesStream(isCurrentUser: true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final foundUserProfile = snapshot.data!;
          if (foundUserProfile.isNotEmpty) {
            return ListTile(
              leading:
                  UserCircleAvatar(imageUrl: foundUserProfile.first.imageUrl),
              title: Text(
                  '${foundUserProfile.first.name} ${foundUserProfile.first.surname}'),
              subtitle: Text(foundUserProfile.first.email),
            );
          }
        } else if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: 'User Error',
            exception: Exception(snapshot.error),
            defaultActionText: 'Dismiss',
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget _buildFormStream() {
    return StreamBuilder<List<CreatedCourse>>(
      stream: widget.database.coursesStream(false),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final createdCourses = snapshot.data!;
          // if (createdCourses.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                controller: _textController,
                labelText: 'Course IV',
                hintText: 'e.g NJ6kEDU312',
                onChanged: (value) {
                  setState(() {
                    _canSubmit = true;
                  });
                  if (value.isEmpty) {
                    _canSubmit = false;
                  }
                },
              ),
              const SizedBox(height: 15.0),
              CustomElevatedButton(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        'JOIN COURSE',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.white, fontSize: 16.0),
                      ),
                height: 50.0,
                onPressed: !_canSubmit ? null : () => _submit(createdCourses),
              ),
            ],
          );
          // } else {
          //   const Text('No courses yet');
          // }
        } else if (snapshot.hasError) {
          showExceptionAlertDialog(
            context,
            title: 'Course not found',
            exception: Exception('No course matches your course IV'),
            defaultActionText: 'Dismiss',
          );
        }
        return const LinearProgressIndicator();
      },
    );
  }
}
