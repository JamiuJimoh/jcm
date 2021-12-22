import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'courses_bloc.dart';
import 'models/created_course.dart';
import 'validators.dart';

class EditCoursePage extends StatefulWidget with CourseValidators {
  static const id = 'edit_course_page';

  final Database database;
  final AuthBase auth;
  final CreatedCourse? course;
  final CoursesBloc bloc;

  EditCoursePage({
    required this.database,
    required this.auth,
    required this.bloc,
    this.course,
  });

  static Future<void> show(BuildContext context,
      {CreatedCourse? course}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Provider<CoursesBloc>(
          create: (_) => CoursesBloc(database: database, auth: auth),
          child: Consumer<CoursesBloc>(
            builder: (_, bloc, __) => EditCoursePage(
              database: database,
              auth: auth,
              course: course,
              bloc: bloc,
            ),
          ),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _courseTitleEmpty = false;
  var _courseCodeEmpty = false;

  var _initialValue = <String, dynamic>{
    'courseTitle': '',
    'courseCode': '',
  };

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _initialValue = {
        'courseTitle': widget.course?.courseTitle,
        'courseCode': widget.course?.courseCode,
      };
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String _generateCourseIV({required String courseCode}) {
    Random random = Random();
    int randomNumber = random.nextInt(10);
    final teacherId = widget.auth.currentUser!.uid;

    final localGen =
        teacherId.substring(randomNumber, 14) + courseCode.replaceAll(' ', '');

    const uuid = Uuid();

    final uuidGen = uuid.v5(Uuid.NAMESPACE_URL, localGen);

    final splitted = uuidGen.split('-');

    final finalCourseIV = splitted[1][0] + splitted[3][3] + splitted[0];

    return finalCourseIV;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });

        final courseId = widget.course?.courseId ?? documentIdFromCurrentDate();
        final teacherId = widget.auth.currentUser!.uid;
        final courseIV =
            _generateCourseIV(courseCode: _initialValue['courseCode']);
        final course = CreatedCourse(
          courseId: courseId,
          teacherId: teacherId,
          courseIV: courseIV,
          courseTitle: _initialValue['courseTitle'],
          courseCode: _initialValue['courseCode'],
          teacherName: '',
        );
        await widget.database.setCourse(course);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        setState(() {
          _isLoading = false;
        });
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  bool canSubmit() {
    return _courseCodeEmpty && _courseTitleEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course != null ? 'Edit Course' : 'Create Course',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    initialValue: _initialValue['courseTitle'],
                    labelText: 'Course title',
                    hintText: 'e.g Automata & Data Structure',
                    onSaved: (value) => _initialValue['courseTitle'] = value,
                    onChanged: (value) {
                      setState(() {
                        _courseTitleEmpty = true;
                      });
                      if (value.isEmpty) {
                        _courseTitleEmpty = false;
                      }
                    },
                    validator: (value) =>
                        widget.courseTitleValidator.isValid(value!)
                            ? null
                            : widget.invalidCourseTitleErrorText,
                  ),
                  const SizedBox(height: 12.0),
                  CustomTextFormField(
                    initialValue: _initialValue['courseCode'],
                    labelText: 'Course code',
                    hintText: 'e.g CSC 401',
                    onSaved: (value) => _initialValue['courseCode'] = value,
                    onChanged: (value) {
                      setState(() {
                        _courseCodeEmpty = true;
                      });
                      if (value.isEmpty) {
                        _courseCodeEmpty = false;
                      }
                    },
                    validator: (value) =>
                        widget.courseCodeValidator.isValid(value!)
                            ? null
                            : widget.invalidCourseCodeErrorText,
                  ),
                  const SizedBox(height: 20.0),
                  CustomElevatedButton(
                    width: double.infinity,
                    height: 47.00,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'Create Course',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.white, fontSize: 16.0),
                          ),
                    onPressed: !canSubmit() ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
