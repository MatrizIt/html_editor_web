import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfHelper {
  Future<String> createPDF(String text) async {
    try {
      final fontBytes = await rootBundle.load('assets/fonts/Inter-Regular.ttf');
      final pdf = pw.Document();
      final widgets = await HTMLToPdf().convert(text);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: widgets,
            );
          },
        ),
      );

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
}
