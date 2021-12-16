import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/custom_text_form_field.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../services/database.dart';
import '../../models/classroom_convo_thread.dart';

class BuildBottomTextField extends StatefulWidget {
  const BuildBottomTextField({
    Key? key,
    required this.thread,
    required this.uid,
    required this.classroomID,
    required this.database,
  }) : super(key: key);
  final ClassroomConvoThread? thread;
  final String uid;
  final String classroomID;
  final Database database;

  @override
  BuildBottomTextFieldState createState() => BuildBottomTextFieldState();
}

class BuildBottomTextFieldState extends State<BuildBottomTextField> {
  final _formKey = GlobalKey<FormState>();

  final _controller = TextEditingController();

  var _isLoading = false;

  String? _message;

  @override
  void initState() {
    super.initState();
    if (widget.thread != null) {
      _message = widget.thread!.message;
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

  Future<void> _send(Database database) async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final threadID = widget.thread?.threadID ?? documentIdFromCurrentDate();
        final thread = ClassroomConvoThread(
          threadID: threadID,
          message: _message!,
          senderID: widget.uid,
          createdAt: Timestamp.now(),
        );

        await database.setCourseConvoThread(widget.classroomID, thread);
        setState(() {
          _isLoading = false;
        });
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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Form(
        key: _formKey,
        child: CustomTextFormField(
          controller: _controller,
          suffixIcon: GestureDetector(
            onTap: _isLoading
                ? null
                : () {
                    _send(widget.database);
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                  },
            child: const Icon(
              Icons.send,
            ),
          ),
          // initialValue: _message,
          labelText: 'Add a comment...',
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
    );
  }
}
