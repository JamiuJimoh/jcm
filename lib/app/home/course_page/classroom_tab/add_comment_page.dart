import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/models/user_classroom.dart';
import 'package:jamiu_class_manager/app/utils/months.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/common_widgets/user_circle_avatar.dart';

class AddCommentPage extends StatelessWidget {
  AddCommentPage({required this.userClassroom});
  final UserClassroom userClassroom;

  static Future<void> show(BuildContext context,
      {required UserClassroom userClassroom}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddCommentPage(userClassroom: userClassroom),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _BuildBottomTextField(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            title: Text(
              '${userClassroom.userProfile?.name} ${userClassroom.userProfile?.surname}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 16.0),
            ),
            subtitle: Row(
              children: [
                Text(
                  '${userClassroom.classroom.createdAt.toDate().day} ${Months.getMonth(userClassroom.classroom.createdAt.toDate().month)} ${userClassroom.classroom.createdAt.toDate().year} ',
                ),
              ],
            ),
            leading: UserCircleAvatar(
              imageUrl: userClassroom.userProfile?.imageUrl,
              radius: 35.0,
            ),
          ),
          ..._buildDivider(),
          Text(
            userClassroom.classroom.message,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
          ),
          const SizedBox(height: 45.0),
          ..._buildDivider(),
          Text('Class Comments')
        ],
      ),
    );
  }

  List<Widget> _buildDivider() {
    return [
      const SizedBox(height: 5.0),
      const Divider(
        thickness: 1.0,
      ),
      const SizedBox(height: 10.0),
    ];
  }
}

class _BuildBottomTextField extends StatefulWidget {
  const _BuildBottomTextField({Key? key}) : super(key: key);

  @override
  __BuildBottomTextFieldState createState() => __BuildBottomTextFieldState();
}

class __BuildBottomTextFieldState extends State<_BuildBottomTextField> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  String? _message;

  @override
  void initState() {
    super.initState();
    // if (widget.classroom != null) {
    //   _message = widget.classroom!.message;
    // }
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
    // if (_validateAndSaveForm()) {
    //   try {
    //     setState(() {
    //       _isLoading = true;
    //     });
    //     final classroomID =
    //         widget.classroom?.classroomID ?? documentIdFromCurrentDate();
    //     print(widget.auth.currentUser);
    //     final classroom = Classroom(
    //       createdAt: Timestamp.now(),
    //       senderID: widget.auth.currentUser!.uid,
    //       classroomID: classroomID,
    //       courseID: widget.courseID,
    //       message: _message!,
    //     );
    //     await widget.database.setCourseConvo(classroom);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     print(classroom);
    //     Navigator.of(context).pop();
    //   } on FirebaseException catch (e) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     showExceptionAlertDialog(
    //       context,
    //       title: 'Operation failed',
    //       exception: e,
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Form(
        key: _formKey,
        child: CustomTextFormField(
          suffixIcon: Icon(Icons.send),
          initialValue: _message,
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
