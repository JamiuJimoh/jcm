import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

import 'validators.dart';

class JoinCoursePage extends StatefulWidget with CourseValidators {
  static const id = 'join_course_page';

  @override
  _JoinCoursePageState createState() => _JoinCoursePageState();
}

class _JoinCoursePageState extends State<JoinCoursePage> {
  final _formKey = GlobalKey<FormState>();

  var _courseIV = '';

  var _isLoading = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() {
    if (_validateAndSaveForm()) {}
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
                Consumer<AuthBase>(builder: (_, auth, __) {
                  final user = auth.currentUser!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoURL == null
                          ? AssetImage(
                                  'assets/images/blank-profile-picture.png')
                              as ImageProvider
                          : NetworkImage(
                              user.photoURL!,
                            ),
                    ),
                    title: Text(user.displayName!),
                    subtitle: Text(user.email!),
                  );
                }),
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
