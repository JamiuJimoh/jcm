import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/models/user_profile.dart';
import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'pick_image_container.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.database,
    required this.auth,
    required this.userProfile,
  });
  final Database database;
  final AuthBase auth;
  final UserProfile userProfile;

  static Future<void> show(BuildContext context,
      {required UserProfile userProfile}) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) => SettingsPage(
              auth: auth,
              database: database,
              userProfile: userProfile,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  String? _name;
  String? _surname;

  @override
  void initState() {
    super.initState();
    _name = widget.userProfile.name;
    _surname = widget.userProfile.surname;
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

        print(widget.auth.currentUser);
        final userProfile = UserProfile(
          userID: widget.userProfile.userID,
          name: _name!,
          surname: _surname!,
          email: widget.userProfile.email,
          imageUrl: widget.userProfile.imageUrl,
        );
        await widget.database
            .setUserProfile(userProfile, widget.auth.currentUser!.uid);
        setState(() {
          _isLoading = false;
        });
        print(userProfile);
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
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(child: PickImageContainer(context)),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  initialValue: _name,
                  labelText: 'Name',
                  onSaved: (val) => _name = val,
                  validator: (val) {
                    if (val != null) {
                      if (val.isNotEmpty) {
                        return null;
                      }
                    }
                    return 'Name cannot be empty';
                  },
                ),
                const SizedBox(height: 10.0),
                CustomTextFormField(
                  initialValue: _surname,
                  labelText: 'Surname',
                  onSaved: (val) => _surname = val,
                  validator: (val) {
                    if (val != null) {
                      if (val.isNotEmpty) {
                        return null;
                      }
                    }
                    return 'Surname cannot be empty';
                  },
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  // height: double.infinity,
                  onPressed: _send,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Update Profile',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           _isLoading
//               ? CircularProgressIndicator()
//               : IconButton(
//                   onPressed: _send,
//                   icon: Icon(
//                     Icons.send,
//                     // color: _isEmptyTextField ? Colors.grey : null,
//                   ),
//                 ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//         child: Form(
//           key: _formKey,
//           child: CustomTextFormField(
//             autofocus: true,
//             initialValue: _message,
//             labelText: 'Share with the class',
//             onSaved: (val) => _message = val,
//             validator: (val) {
//               if (val != null) {
//                 if (val.isNotEmpty) {
//                   return null;
//                 }
//               }
//               return '';
//             },
//           ),
//         ),
//       ),
//     );
//   }