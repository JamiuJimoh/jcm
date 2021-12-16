import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/custom_text_form_field.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../models/classroom.dart';

class EditClassroomConvoPage extends StatefulWidget {
  const EditClassroomConvoPage({Key? key, 
    required this.database,
    required this.courseID,
    required this.auth,
    this.classroom,
  }) : super(key: key);
  final Database database;
  final String courseID;
  final Classroom? classroom;
  final AuthBase auth;

  @override
  _EditClassroomConvoPageState createState() => _EditClassroomConvoPageState();

  static Future<void> show(BuildContext context,
      {Classroom? classroom, required String courseID}) async {
    // final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) => EditClassroomConvoPage(
              auth: auth,
              database: database,
              classroom: classroom,
              courseID: courseID,
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class _EditClassroomConvoPageState extends State<EditClassroomConvoPage> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  String? _message;

  @override
  void initState() {
    super.initState();
    if (widget.classroom != null) {
      _message = widget.classroom!.message;
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

  Future<void> _send() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final classroomID =
            widget.classroom?.classroomID ?? documentIdFromCurrentDate();
        print(widget.auth.currentUser);
        final classroom = Classroom(
          createdAt: Timestamp.now(),
          senderID: widget.auth.currentUser!.uid,
          classroomID: classroomID,
          courseID: widget.courseID,
          message: _message!,
        );
        await widget.database.setCourseConvo(classroom);
        setState(() {
          _isLoading = false;
        });
        print(classroom);
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
        actions: [
          _isLoading
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: _send,
                  icon: const Icon(
                    Icons.send,
                    // color: _isEmptyTextField ? Colors.grey : null,
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: CustomTextFormField(
            autofocus: true,
            initialValue: _message,
            labelText: 'Share with the class',
            onSaved: (val) => _message = val,
            validator: (val) {
              if (val != null) {
                if (val.isNotEmpty) {
                  return null;
                }
              }
              return '';
            },
          ),
        ),
      ),
    );
  }

  // List<Widget> _buildDivider() {
  //   return [
  //     const SizedBox(height: 10.0),
  //     const Divider(
  //       thickness: 0.7,
  //     ),
  //     const SizedBox(height: 10.0),
  //   ];
  // }
}
