import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/custom_text_form_field.dart';
import '../../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../../services/auth.dart';
import '../../../../../services/database.dart';
import '../../../models/course_material.dart';

class EditMaterialPage extends StatefulWidget {
  const EditMaterialPage({
    Key? key,
    required this.material,
    required this.courseId,
    required this.database,
    required this.auth,
    required this.isEdit,
  }) : super(key: key);
  final CourseMaterial? material;
  final String courseId;
  final Database database;
  final AuthBase auth;
  final bool isEdit;

  static Future<void> show(context,
      {CourseMaterial? material,
      bool isEdit = false,
      required String courseId}) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) => EditMaterialPage(
              auth: auth,
              database: database,
              material: material,
              courseId: courseId,
              isEdit: isEdit,
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditMaterialPage> createState() => _EditMaterialPageState();
}

class _EditMaterialPageState extends State<EditMaterialPage> {
  var _isLoading = false;
  var _canSubmit = false;

  var _initialValue = <String, dynamic>{
    'title': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();
    if (widget.material != null) {
      _initialValue = {
        'title': widget.material!.title,
        'description': widget.material!.description,
      };
    }
  }

  Future<void> _send() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final materialId =
          widget.material?.materialId ?? documentIdFromCurrentDate();
      final material = CourseMaterial(
        materialId: materialId,
        postedAt: Timestamp.now(),
        title: _initialValue['title'],
        description: _initialValue['description'],
      );

      await widget.database.setMaterial(widget.courseId, material);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      if (widget.isEdit) {
        Navigator.of(context).pop();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : IconButton(
                  onPressed: _canSubmit ? _send : null,
                  icon: const Icon(Icons.send),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: [
            CustomTextFormField(
              autofocus: true,
              initialValue: _initialValue['title'],
              labelText: 'Title',
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {
                  if (val.isNotEmpty) {
                    _canSubmit = true;
                  } else {
                    _canSubmit = false;
                  }
                });
                _initialValue['title'] = val;
              },
            ),
            const SizedBox(height: 20.0),
            CustomTextFormField(
              initialValue: _initialValue['description'],
              labelText: 'Description(optional)',
              onChanged: (val) {
                _initialValue['description'] = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
