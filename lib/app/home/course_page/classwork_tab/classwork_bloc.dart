import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

import '../../../../services/database.dart';
import '../../models/course_material.dart';
import '../../models/material_pdf.dart';
import '../../models/pdf.dart';


class ClassworkBloc{
   ClassworkBloc({required this.database});
  final Database database;

   Stream<List<MaterialPDF>> materialStreamCombiner(String courseID) =>
      Rx.combineLatest2(
        database.materialsStream(courseID),
        database.pdfsStream(),
        _streamCombiner,
      );

  List<MaterialPDF> _streamCombiner(List<CourseMaterial> courseMaterials, List<PDF> pdfs) {
    return courseMaterials.map((material) {
      final foundPDF = pdfs
          .firstWhereOrNull((pdf) => material.materialId == pdf.materialID);
      return MaterialPDF(
        courseMaterial: material,
        pdf: foundPDF,
      );
    }).toList();
  }
}