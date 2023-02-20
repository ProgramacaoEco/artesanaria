import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share_extend/share_extend.dart';

class PDFView extends StatelessWidget {
  PDFView(this.pathPDF);

  final String pathPDF;

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text('Document'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                ShareExtend.share(pathPDF, "file", sharePanelTitle: "Enviar PDF");
              },
            ),
          ],
        ),
        path: pathPDF);
  }
}
