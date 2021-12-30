import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/show_alert_dialog.dart';
import '../../../../../services/auth.dart';
import '../../../../../services/database.dart';
import '../../../models/course_material.dart';
import '../../../models/pdf.dart';
import '../../course_page.dart';
import '../pdf_viewer/pdf_viewer.dart';
import 'classwork_provider.dart';
import 'edit_materials_page.dart';
import 'material_card.dart';

enum Actions { edit, delete }

class CourseMaterialPage extends StatefulWidget {
  const CourseMaterialPage({
    Key? key,
    required this.courseMaterial,
    required this.entityType,
    required this.courseId,
    required this.database,
    required this.provider,
  }) : super(key: key);
  final CourseMaterial courseMaterial;
  final EntityType entityType;
  final String courseId;
  final Database database;
  final ClassworkProvider provider;

  static Future<void> show(
    context, {
    required CourseMaterial courseMaterial,
    required EntityType entityType,
    required String courseId,
  }) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
          child: Consumer<Database>(
            builder: (_, database, __) =>
                ChangeNotifierProvider<ClassworkProvider>(
              create: (_) => ClassworkProvider(),
              child: Consumer<ClassworkProvider>(
                builder: (_, provider, __) => CourseMaterialPage(
                  courseMaterial: courseMaterial,
                  entityType: entityType,
                  courseId: courseId,
                  database: database,
                  provider: provider,
                ),
              ),
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
                    material: widget.courseMaterial,
                  ).then((value) => setState(() {}));
                } else {
                  try {
                    widget.provider.deleteMaterial(
                      widget.database,
                      widget.courseMaterial.materialId,
                      widget.courseId,
                    );
                  } on FirebaseException catch (e) {
                    print(e);
                    showAlertDialog(
                      context: context,
                      title: 'Error',
                      content: 'An error occurred while performing this action',
                      defaultActionText: 'Cancel',
                    );
                  } catch (e) {
                    print(e);
                    showAlertDialog(
                      context: context,
                      title: 'Error',
                      content: 'An error occurred while performing this action',
                      defaultActionText: 'Cancel',
                    );
                  }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25.0),
              Text(
                widget.courseMaterial.title,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 25.0),
              ),
              ..._buildDivider(Theme.of(context).primaryColor),
              Text(
                widget.courseMaterial.description,
                style: const TextStyle(fontSize: 15.0),
              ),
              const SizedBox(height: 20.0),
              StreamBuilder<List<PDF>>(
                  stream: widget.database
                      .pdfsStream(widget.courseMaterial.materialId),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      final pdfs = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pdfs.isNotEmpty) ...[
                            Text(
                              'Attachments',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 20.0)
                          ],
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                              // mainAxisExtent: 270.0,
                            ),
                            itemCount: pdfs.length,
                            itemBuilder: (_, i) {
                              return MaterialCard(
                                title: pdfs[i].title,
                                onPressed: () => PDFViewer.show(
                                  context,
                                  fileName: pdfs[i].title,
                                  url: pdfs[i].url,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 35.0)
                        ],
                      );
                    }

                    if (snapshot.hasError) {
                      showAlertDialog(
                        context: context,
                        title: 'Error',
                        content: snapshot.error.toString(),
                        defaultActionText: 'Close',
                      );
                      return Text(
                        snapshot.error.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ],
          ),
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
