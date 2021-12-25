import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/auth.dart';
import '../../../../../services/database.dart';
import '../../../models/material_pdf.dart';
import '../../course_page.dart';
import 'edit_materials_page.dart';

enum Actions { edit, delete }

class CourseMaterialPage extends StatefulWidget {
  const CourseMaterialPage({
    Key? key,
    required this.materialPDF,
    required this.entityType,
    required this.courseId,
    required this.database,
    required this.listLength,
  }) : super(key: key);
  final MaterialPDF materialPDF;
  final EntityType entityType;
  final String courseId;
  final Database database;
  final int listLength;

  static Future<void> show(
    context, {
    required MaterialPDF materialPDF,
    required EntityType entityType,
    required String courseId,
    required int listLength,
  }) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) => CourseMaterialPage(
              listLength: listLength,
              materialPDF: materialPDF,
              entityType: entityType,
              courseId: courseId,
              database: database,
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<CourseMaterialPage> createState() => _CourseMaterialPageState();
}

class _CourseMaterialPageState extends State<CourseMaterialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.entityType == EntityType.instructor)
            PopupMenuButton<Actions>(
              color: Theme.of(context).primaryColor,
              onSelected: (action) {
                if (action == Actions.edit) {
                  EditMaterialPage.show(
                    context,
                    courseId: widget.courseId,
                    material: widget.materialPDF.courseMaterial,
                    isEdit: true,
                  );
                } else {
                  widget.database.deleteMaterial(
                    widget.courseId,
                    widget.materialPDF.courseMaterial.materialId,
                  );
                  Navigator.of(context).pop();
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: Actions.edit,
                    child: Text('Edit',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.white)),
                  ),
                  PopupMenuItem(
                    value: Actions.delete,
                    child: Text('Delete',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.white)),
                  ),
                ];
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25.0),
            Text(
              widget.materialPDF.courseMaterial.title,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 25.0),
            ),
            ..._buildDivider(Theme.of(context).primaryColor),
            Text(
              widget.materialPDF.courseMaterial.description,
              style: const TextStyle(fontSize: 15.0),
            ),
            const SizedBox(height: 25.0),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                // crossAxisSpacing: 5.0,
                // mainAxisSpacing: 5.0,
                // mainAxisExtent: 2.0
              ),
              itemCount: widget.listLength,
              itemBuilder: (_, i) {
                return Container(
                  // height: 100,
                  color: Colors.blue,
                  child: Text("index: ${widget.materialPDF.pdf?.pdf}"),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDivider([Color? color]) {
    return [
      const SizedBox(height: 10.0),
      Divider(
        thickness: 0.7,
        color: color,
      ),
      const SizedBox(height: 15.0),
    ];
  }
}
