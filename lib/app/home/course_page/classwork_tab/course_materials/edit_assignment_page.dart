import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../common_widgets/custom_text_form_field.dart';
import '../../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../../services/auth.dart';
import '../../../../../services/database.dart';
import '../../../models/course_assignment.dart';
import 'attachment_section.dart';
import 'classwork_provider.dart';

class EditAssignmentPage extends StatefulWidget {
  const EditAssignmentPage({
    Key? key,
    required this.assignment,
    required this.courseId,
    required this.database,
    required this.auth,
    required this.provider,
  }) : super(key: key);
  final CourseAssignment? assignment;
  final String courseId;
  final Database database;
  final AuthBase auth;
  final ClassworkProvider provider;

  static Future<void> show(context,
      {CourseAssignment? assignment, required String courseId}) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) =>
                ChangeNotifierProvider<ClassworkProvider>(
              create: (_) => ClassworkProvider(),
              child: Consumer<ClassworkProvider>(
                builder: (_, provider, __) => EditAssignmentPage(
                  auth: auth,
                  database: database,
                  assignment: assignment,
                  courseId: courseId,
                  provider: provider,
                ),
              ),
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditAssignmentPage> createState() => _EditAssignmentPageState();
}

class _EditAssignmentPageState extends State<EditAssignmentPage> {
  var _isLoading = false;
  var _canSubmit = false;
  var _showTimePicker = false;

  var _initialValue = <String, dynamic>{
    'title': '',
    'description': '',
    'points': 100,
    'dueDate': 'no due date',
    'postedAt': '',
  };

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      _initialValue = {
        'title': widget.assignment!.title,
        'description': widget.assignment!.description,
        'points': widget.assignment!.points,
      };
    }
  }

  Future<void> _send() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final assignmentId = widget.assignment?.assignmentId ?? const Uuid().v4();
      final assignment = CourseAssignment(
        assignmentId: assignmentId,
        title: _initialValue['title'],
        description: _initialValue['description'],
        postedAt: Timestamp.now(),
        dueDate: Timestamp.now(),
        points: 100,
      );
      print(assignment);

      await widget.database.setAssignment(widget.courseId, assignment);

      await widget.provider.sendPickedPDFs(
          database: widget.database, classworkItemID: assignmentId);

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

  Future<DateTime?> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, 1),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _showTimePicker = true;
      });
      return pickedDate;
    }
  }

  Future<TimeOfDay?> _selectTime() async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      return pickedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isLoading ? null : const Text('Loading...'),
        actions: [
          if (!_isLoading) ...[
            IconButton(
              icon: const Icon(Icons.attachment_outlined),
              onPressed: () => widget.provider.getPDF(),
            ),
            IconButton(
              onPressed: _canSubmit ? _send : null,
              icon: const Icon(Icons.send),
            ),
          ]
        ],
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: const Size(double.infinity, 4.0),
                child: LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ))
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                autofocus: true,
                initialValue: _initialValue['title'],
                labelText: 'Title',
                textInputAction: TextInputAction.next,
                enabled: _isLoading ? false : true,
                readOnly: _isLoading ? true : false,
                onChanged: (val) {
                  setState(() {
                    if (widget.assignment == null) {
                      if (val.isNotEmpty) {
                        _canSubmit = true;
                      } else {
                        _canSubmit = false;
                      }
                    } else {
                      if (val.isNotEmpty) {
                        _canSubmit = true;
                      } else {
                        _canSubmit = false;
                      }
                    }
                  });
                  _initialValue['title'] = val;
                },
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                initialValue: _initialValue['description'],
                labelText: 'Description(optional)',
                enabled: _isLoading ? false : true,
                readOnly: _isLoading ? true : false,
                onChanged: (val) {
                  _initialValue['description'] = val;
                },
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Text('Points', style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(width: 20.0),
                  SizedBox(
                    width: 100.0,
                    child: CustomTextFormField(
                      initialValue: _initialValue['points'].toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      enabled: _isLoading ? false : true,
                      readOnly: _isLoading ? true : false,
                      onChanged: (val) {
                        _initialValue['points'] = int.tryParse(val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Due', style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(width: 20.0),
                  InkWell(
                    onTap: () async {
                      print('*************');
                      print(await _selectDate());
                      print('*************');
                    },
                    child: SizedBox(
                      width: 130.0,
                      child: CustomTextFormField(
                        initialValue: _initialValue['dueDate'].toString(),
                        enabled: false,
                        readOnly: true,
                        // onChanged: (val) {
                        //   _initialValue['points'] = int.tryParse(val);
                        // },
                      ),
                    ),
                  ),
                  if (_showTimePicker) ...[
                    const SizedBox(width: 20.0),
                    InkWell(
                      onTap: () async {
                        print('*************');
                        print(await _selectTime());
                        print('*************');
                      },
                      child: SizedBox(
                        width: 130.0,
                        child: CustomTextFormField(
                          initialValue: _initialValue['dueDate'].toString(),
                          enabled: false,
                          readOnly: true,
                          // onChanged: (val) {
                          //   _initialValue['points'] = int.tryParse(val);
                          // },
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              // const SizedBox(height: 20.0),

              const SizedBox(height: 30.0),
              AttachmentSection(provider: widget.provider),
            ],
          ),
        ),
      ),
    );
  }
}
