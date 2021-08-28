import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/models/user_profile.dart';
import 'package:jamiu_class_manager/common_widgets/custom_elevated_button.dart';
import 'package:jamiu_class_manager/common_widgets/custom_text_form_field.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import 'image_input.dart';

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
  File? _pickedImage;

  var _isLoading = false;

  String? _name;
  String? _surname;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _name = widget.userProfile.name;
    _surname = widget.userProfile.surname;
    _userImageUrl = widget.userProfile.imageUrl;
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
    String? imgUrl;
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });

        print(widget.auth.currentUser);
        if (_pickedImage != null) {
          final url = await widget.database.setImageData(_pickedImage!);
          imgUrl = url;
        }
        final userProfile = UserProfile(
          userID: widget.userProfile.userID,
          name: _name!,
          surname: _surname!,
          email: widget.userProfile.email,
          imageUrl: imgUrl ?? _userImageUrl!,
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
                ImageInput(
                  pickedImageFn: (image) => _pickedImage = image,
                  initialImage: _userImageUrl ?? '',
                ),
                const SizedBox(height: 40.0),
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
                  height: 50.0,
                  width: double.infinity,
                  onPressed: _isLoading ? null : _send,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Update Profile',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
