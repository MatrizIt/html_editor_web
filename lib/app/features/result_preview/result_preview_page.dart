import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ResultPreviewPage extends StatefulWidget {
  final String result;
  final String phone;
  final String idProcedure;
  final String idSurvey;
  const ResultPreviewPage({
    super.key,
    required this.result, required this.phone, required this.idProcedure, required this.idSurvey,
  });

  @override
  State<ResultPreviewPage> createState() => _ResultPreviewPageState();
}



class _ResultPreviewPageState extends State<ResultPreviewPage> {
  late final IRelatoryRepository repository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    repository = Modular.get<IRelatoryRepository>();
  }


  void generateDocu() async {
    log("Texto > ${widget.result}");
    var data = await repository.getPreviewReport(widget.phone, int.parse(widget.idProcedure),int.parse(widget.idSurvey),widget.result, false);

    String base64StringFromAPI = data; // Substitua pelo seu base64
    List<int> bytes = base64.decode(base64StringFromAPI.replaceAll('"', ""));

    var directory = await getExternalStorageDirectory();
    String docxFilePath = '${directory?.path}/reportPad.docx';

    try {
      File docxFile = await File(docxFilePath).writeAsBytes(bytes);

      OpenFile.open(docxFile.path.substring(1, docxFile.path.length));
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 160, 0, 100),
        onPressed: () {
          generateDocu();
        },
        child: const Icon(
          Icons.document_scanner_sharp,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(),
      body: Zoom(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: HtmlWidget(
              widget.result,
              renderMode: RenderMode.column,

            ),
          ),
        ),
      ),
    );
  }
}
