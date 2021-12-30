import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/models/course_assignment.dart';
import 'package:jamiu_class_manager/app/home/models/course_material.dart';
import 'package:jamiu_class_manager/app/home/models/pdf.dart';
import 'package:uuid/uuid.dart';

import '../../../../../services/database.dart';

class ClassworkProvider extends ChangeNotifier {
  final List<File> _files = [];

  List<File> get files => _files;

  List<String> generateTitles() {
    final List<String> titles = [];
    for (var file in _files) {
      titles.add(generateTitle(file));
    }
    return titles;
  }

  String generateTitle(File file) {
    final title = file.path.split('/');
    return title.last;
  }

  Future<void> getPDF() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      for (var path in result.paths) {
        _files.add(File(path!));
      }
    }
    notifyListeners();
  }

  File convertStringToFile(String item) {
    return _files.firstWhere(
      (file) => file.path.split('/').last == item,
    );
  }

  Future<void> sendPickedPDFs({
    required String classworkItemID,
    required Database database,
  }) async {
    try {
      await Future.wait(_files.map(
        (file) async {
          const uuid = Uuid();
          final pdfId = uuid.v4();
          final url = await database.postPDF(file, pdfId);
          final pdf = PDF(
            pdfID: pdfId,
            title: generateTitle(file),
            url: url,
            classworkItemID: classworkItemID,
          );
          return database.setPDF(pdf);
        },
      ));
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  void removeFile(String title) {
    final foundFile = convertStringToFile(title);
    final isRemoved = _files.remove(foundFile);
    if (isRemoved) notifyListeners();
  }

  Future<void> deleteMaterial(
      Database database, String materialID, String courseID) async {
    try {
      database.pdfsStream(materialID).listen((pdfs) async {
        for (var pdf in pdfs) {
          try {
            await database.deletePDFStorage(pdf.url);
            await database.deletePDFFirestore(pdf.pdfID);
          } on FirebaseException catch (_) {
            rethrow;
          }
        }
      });
      await database.deleteMaterial(
        courseID,
        materialID,
      );
    } on FirebaseException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
