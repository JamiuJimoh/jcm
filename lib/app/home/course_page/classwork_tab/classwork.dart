import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/show_alert_dialog.dart';
import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../../utils/months.dart';
import '../../list_items_builder.dart';
import '../../models/course_material.dart';
import '../course_page.dart';
import 'course_materials/classwork_provider.dart';
import 'course_materials/course_material_page.dart';
import 'widgets/bottom_sheet_content.dart';

class Classwork extends StatefulWidget {
  const Classwork({
    Key? key,
    required this.courseID,
    required this.entityType,
    required this.auth,
    required this.database,
    required this.provider,
  }) : super(key: key);
  final String courseID;
  final EntityType entityType;
  final AuthBase auth;
  final Database database;
  final ClassworkProvider provider;

  static Widget create(
    context, {
    required String courseID,
    required EntityType entityType,
  }) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<Database>(
      create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
      child: Consumer<Database>(
        builder: (_, database, __) => ChangeNotifierProvider<ClassworkProvider>(
          create: (_) => ClassworkProvider(),
          child: Consumer<ClassworkProvider>(
            builder: (_, provider, __) => Classwork(
              auth: auth,
              database: database,
              courseID: courseID,
              provider: provider,
              entityType: entityType,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _ClassworkState createState() => _ClassworkState();
}

class _ClassworkState extends State<Classwork> {
  var _isLoading = false;

  Future<void> _buildModalBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      context: context,
      builder: (_) => BottomSheetContent(courseId: widget.courseID),
    );
  }

  Future<void> _delete(String materialId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.provider.deleteMaterial(
        widget.database,
        materialId,
        widget.courseID,
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'An error occurred while performing this action',
        defaultActionText: 'Cancel',
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      showAlertDialog(
        context: context,
        title: 'Error',
        content: 'An error occurred while performing this action',
        defaultActionText: 'Cancel',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.entityType == EntityType.instructor
          ? FloatingActionButton(
              onPressed: _buildModalBottomSheet,
              child: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: StreamBuilder<List<CourseMaterial>>(
          stream: widget.database.materialsStream(widget.courseID),
          builder: (_, snapshot) {
            return ListItemsBuilder<CourseMaterial>(
              snapshot: snapshot,
              emptyStateTitle: 'No Classwork',
              emptyStateMessage: widget.entityType == EntityType.student
                  ? ''
                  : 'You haven\'t created any classwork yet',
              reverseList: false,
              itemBuilder: (_, material) => ListTile(
                leading: _isLoading
                    ? const CircularProgressIndicator()
                    : const CircleAvatar(
                        child: Icon(Icons.class__outlined),
                      ),
                title: Text(material.title),
                subtitle: Text(
                  'Posted on ' + Months.completeDate(material.postedAt),
                  style: const TextStyle(fontSize: 12.0),
                ),
                onTap: () => CourseMaterialPage.show(
                  context,
                  courseMaterial: material,
                  entityType: widget.entityType,
                  courseId: widget.courseID,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _delete(material.materialId),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
