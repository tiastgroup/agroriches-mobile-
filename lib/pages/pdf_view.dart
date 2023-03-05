import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/newsletter.dart';

// ignore: must_be_immutable
class PdfView extends StatelessWidget {
  // int index;
  final NewsletterModel d;

  PdfView( {Key? key,required this.d});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(d.name!)
      ),
      body:SfPdfViewer.network(d.pdfUrl!) ,
    );
  }
}
