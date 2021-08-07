import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/common_widgets/user_circle_avatar.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'course_change_notifier.dart';
import 'courses_bloc.dart';
import 'validators.dart';

class JoinCoursePage extends StatefulWidget with CourseValidators {
  static const id = 'join_course_page';

  final Database database;
  final AuthBase auth;
  // final CourseChangeNotifier change;

  JoinCoursePage({
    required this.database,
    required this.auth,
    // required this.change,
  });

  static Future<void> create(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<CoursesBloc>(
          create: (_) => CoursesBloc(database: database, auth: auth),
          child: JoinCoursePage(
            database: database,
            auth: auth,
            // change: change,
          ),
        ),
        fullscreenDialog: true,
      ),
    );
    // await Navigator.of(context).push(
    //   // TODO: FIX 'WRONG COURSEIV ERROR' ERROR.
    //   MaterialPageRoute(
    //     builder: (_) => ChangeNotifierProvider<CourseChangeNotifier>(
    //       create: (_) => CourseChangeNotifier(),
    //       child: Consumer<CourseChangeNotifier>(
    //         builder: (_, change, __) => JoinCoursePage(
    //           database: database,
    //           auth: auth,
    //           change: change,
    //         ),
    //       ),
    //     ),
    //     fullscreenDialog: true,
    //   ),
    // );
  }

  @override
  _JoinCoursePageState createState() => _JoinCoursePageState();
}

class _JoinCoursePageState extends State<JoinCoursePage> {
  final _formKey = GlobalKey<FormState>();

  var _courseIV = '';

  User get user => widget.auth.currentUser!;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      //  await BlocBuilder<CoursesBloc, bool>(
      //    builder: (context, state)=> context.read<CoursesBloc>().joinCourse(_courseIV),
      //   );
      await context.read<CoursesBloc>().joinCourse(_courseIV);
      // ;

      // context.read<CoursesBloc>().didEmitError();
      // BlocListener<CoursesBloc, bool>(
      //   listener: (context, state) {
      //     print('===========');
      //     print(state);
      //     if (state) {
      //       return null;
      //     } else {
      //       showExceptionAlertDialog(
      //         context,
      //         title: 'Course not found',
      //         exception: Exception('No course matches your course IV'),
      //         defaultActionText: 'Dismiss',
      //       );
      //     }
      //   },
      //   // child: Container(),
      // );
      BlocListener<CoursesBloc, bool>(
        listener: (context, state) {
          print('===========');
          print(state);
          if (!state) {
            showExceptionAlertDialog(
              context,
              title: 'Course not found',
              exception: Exception('No course matches your course IV'),
              defaultActionText: 'Dismiss',
            );
          }
        },
        // child: Container(),
      );
      // if (context.read<CoursesBloc>().didEmitError()) {
      // showExceptionAlertDialog(
      //   context,
      //   title: 'Course not found',
      //   exception: Exception('No course matches your course IV'),
      //   defaultActionText: 'Dismiss',
      // );
      // }

      // await widget.change.joinCourse(
      //   courseIV: _courseIV,
      //   database: widget.database,
      //   auth: widget.auth,
      // );
      // if (widget.change.isError) {
      //   showExceptionAlertDialog(
      //     context,
      //     title: 'Course not found',
      //     exception: Exception('No course matches your course IV'),
      //     defaultActionText: 'Dismiss',
      //   );
      // }
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.bloc.dispose();
  // }

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
    return Form(
      key: _formKey,
      child: Padding(
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15.0, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15.0),
                CustomTextFormField(
                  // initialValue: _initialValue['courseCode'],
                  labelText: 'Course IV',
                  hintText: 'e.g NJ6kEDU312',
                  onSaved: (value) => _courseIV = value!,
                  validator: (value) => widget.courseIVValidator.isValid(value!)
                      ? null
                      : widget.invalidCourseIVErrorText,
                ),
                const SizedBox(height: 15.0),
                CustomElevatedButton(
                  child: Text(
                    'JOIN COURSE',
                  ),
                  height: 50.0,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
