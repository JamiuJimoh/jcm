import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pdf_viewer/pdf_viewer.dart';
import 'classwork_provider.dart';

class AttachmentSection extends StatelessWidget {
  const AttachmentSection({Key? key, required this.provider}) : super(key: key);
  final ClassworkProvider provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassworkProvider>.value(
      value: provider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.files.isNotEmpty) ...[
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
            itemCount: provider.files.length,
            itemBuilder: (_, i) {
              final fileTitles = provider.generateTitles();
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
                    onPressed: () => provider.removeFile(fileTitles[i])),
                onTap: () => PDFViewer.show(
                  context,
                  fileName: fileTitles[i],
                  file: provider.convertStringToFile(fileTitles[i]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
