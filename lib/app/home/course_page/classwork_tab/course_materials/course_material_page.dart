import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/auth.dart';
import '../../../../../services/database.dart';
import '../../../models/course_material.dart';
import '../../course_page.dart';
import 'edit_materials_page.dart';

enum Actions { edit, delete }

class CourseMaterialPage extends StatefulWidget {
  const CourseMaterialPage({
    Key? key,
    required this.material,
    required this.entityType,
    required this.courseId,
    required this.database,
  }) : super(key: key);
  final CourseMaterial material;
  final EntityType entityType;
  final String courseId;
  final Database database;

  static Future<void> show(
    context, {
    required CourseMaterial material,
    required EntityType entityType,
    required String courseId,
  }) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) => CourseMaterialPage(
              material: material,
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
                    material: widget.material,
                    isEdit: true,
                  );
                } else {
                  widget.database.deleteMaterial(
                    widget.courseId,
                    widget.material.materialId,
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
              widget.material.title,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 25.0),
            ),
            ..._buildDivider(Theme.of(context).primaryColor),
            Text(
              widget.material.description,
              style: const TextStyle(fontSize: 15.0),
            ),
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
