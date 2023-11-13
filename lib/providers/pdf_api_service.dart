import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class PDFApiService {

  static Future<String> loadPDF(String pdfUrl) async {
    var response = await http.get(Uri.parse(pdfUrl));
    var dir = await getTemporaryDirectory();
    // var dir = await getDownloadsDirectory();
    File filePath = File(p.join(dir.path, "data.pdf"));
    await filePath.writeAsBytes(response.bodyBytes, flush: true);
    return filePath.path;
  }
}