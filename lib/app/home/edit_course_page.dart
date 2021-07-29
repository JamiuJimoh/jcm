import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'models/created_course.dart';
import 'validators.dart';

class EditCoursePage extends StatefulWidget with CourseValidators {
  static const id = 'edit_course_page';

  final Database database;
  final AuthBase auth;
  final CreatedCourse? course;

  EditCoursePage({
    required this.database,
    required this.auth,
    this.course,
  });

  static Future<void> show(BuildContext context,
      {CreatedCourse? course}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditCoursePage(database: database, auth: auth, course: course),
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
    Random random = new Random();
    int randomNumber = random.nextInt(10);
    final teacherId = widget.auth.currentUser!.uid;

    final courseIV =
        teacherId.substring(randomNumber, 14) + courseCode.replaceAll(' ', '');
    return courseIV;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final courseId = widget.course?.courseId ?? documentIdFromCurrentDate();
        final teacherName = widget.auth.currentUser?.displayName ?? 'Jam';
        final teacherId = widget.auth.currentUser!.uid;
        final courseIV =
            _generateCourseIV(courseCode: _initialValue['courseCode']);
        final course = CreatedCourse(
          courseId: courseId,
          teacherId: teacherId,
          courseIV: courseIV,
          courseTitle: _initialValue['courseTitle'],
          courseCode: _initialValue['courseCode'],
          teacherName: teacherName,
        );
        await widget.database.setCourse(course);
        setState(() {
          _isLoading = false;
        });
        print(course);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course != null ? 'Edit Course' : 'Create Course',
        ),
        actions: [
          _isLoading
              ? CircularProgressIndicator()
              : IconButton(
                  onPressed: _isLoading ? null : _submit,
                  icon: Icon(Icons.save),
                ),
        ],
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
                    validator: (value) =>
                        widget.courseCodeValidator.isValid(value!)
                            ? null
                            : widget.invalidCourseCodeErrorText,
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
