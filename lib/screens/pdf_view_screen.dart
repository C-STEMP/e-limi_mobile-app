import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../constants.dart';
import '../providers/pdf_api_service.dart';


class PDFViewerScreen extends StatefulWidget {

  final String pdfUrl;
  const PDFViewerScreen({super.key, required this.pdfUrl});



  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {

  String? _localFile;

@override
void initState(){
  super.initState();
  PDFApiService.loadPDF(widget.pdfUrl).then((value) => {
    setState((){
  _localFile = value;
  debugPrint(_localFile);
  })

  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("E-limi PDF Viewer", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: _localFile != null ? SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PDFView(
              filePath: _localFile,
            swipeHorizontal: true,
            enableSwipe: true,
          ),
        ),
      ):  SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(child: CircularProgressIndicator(color: kPrimaryColor,))
    ),
    );
  }
}
