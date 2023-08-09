import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfHelper{
  Future<String> createPDF(String text) async{
    try{
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text('Hello, PDF!'),
            );
          },
        ),
      );

      final appDocDir = await getApplicationDocumentsDirectory();
      final pdfPath = appDocDir.path + '/example.pdf';

      final File pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());

      return pdfPath;

    }catch(e){
      print("Error PDF > $e");
      return "Error";
    }
  }
}