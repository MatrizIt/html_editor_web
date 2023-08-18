import 'dart:io';
import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfHelper {
  Future<String> createPDF(String text) async {
    try {
      final fontBytes = await rootBundle.load('assets/fonts/Inter-Regular.ttf');
      final pdf = pw.Document(
        pageMode: PdfPageMode.fullscreen,
      );

      final textParagraphs = _splitTextIntoParagraphs(text); // Implement this function

      for (var paragraph in textParagraphs) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Paragraph(
                    text: paragraph,
                    style: pw.TextStyle(font: pw.Font.ttf(fontBytes)),
                  ),
                ],
              );
            },
          ),
        );
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final pdfPath = '${appDocDir.path}/example.pdf';

      final File pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());


      return pdfPath;
    } catch (e) {
      print("Error PDF > $e");
      return "Error";
    }
  }

  List<String> _splitTextIntoParagraphs(String text) {
    // Split the text into paragraphs based on your criteria
    // You can split by newlines or any other logic that fits your content
    return text.split('\n');
  }
}
