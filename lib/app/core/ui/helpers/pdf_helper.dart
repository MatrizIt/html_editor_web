import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

class PdfHelper{
  Future<void> createPDF(String text) async{
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(text),
        ),
      ),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}