import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/app/home/course_page/classwork_tab/pdf_viewer/pdf_viewer.dart';

class AttachmentSection extends StatelessWidget {
  const AttachmentSection({
    Key? key,
    required this.picked,
    required this.removeFile,
  }) : super(key: key);
  final List<File> picked;
  final void Function(File) removeFile;

  List<String> titles(List<File> files) {
    final titleList = <String>[];
    for (var file in files) {
      final title = file.path.split('/');
      titleList.add(title.last);
    }
    return titleList;
  }

  File _convertStringToFile(List<File> files, String item) {
    return files.firstWhere(
      (file) => file.path.split('/').last == item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (picked.isNotEmpty) ...[
          Text(
            'Attachments',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0)
        ],
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: picked.length,
          itemBuilder: (_, i) {
            final fileTitles = titles(picked);
            return ListTile(
              contentPadding: const EdgeInsets.all(0.0),
              horizontalTitleGap: 0.0,
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(
                fileTitles[i],
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 20.0),
                onPressed: () =>
                    removeFile(_convertStringToFile(picked, fileTitles[i])),
              ),
              onTap: () => PDFViewer.show(
                context,
                fileName: fileTitles[i],
                file: _convertStringToFile(picked, fileTitles[i]),
              ),
            );
          },
        ),
      ],
    );
  }
}
