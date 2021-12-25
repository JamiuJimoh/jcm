import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({
    Key? key,
    required this.file,
    required this.fileName,
  }) : super(key: key);
  final File file;
  final String fileName;

  static Future<void> show(
    context, {
    required File file,
    required String fileName,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PDFViewer(file: file, fileName: fileName),
      ),
    );
  }

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late PdfViewerController _pdfViewerController;

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showModal(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Go to page',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _textController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Enter page number'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 8.0),
                  const Text('22/23'),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: Text(
                          'CANCEL',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor),
                        ),
                      ),
                      const SizedBox(width: 30.0),
                      GestureDetector(
                        onTap: () {
                          _pdfViewerController.jumpToPage(
                              int.tryParse(_textController.text) ?? 0);
                          _textController.text = '';
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: SfPdfViewer.file(widget.file, controller: _pdfViewerController),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModal(context),
        child: const Icon(Icons.search),
      ),
    );
  }
}
