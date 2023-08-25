import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:reportpad/app/features/relatory/view/relatory_view.dart';
import 'package:reportpad/app/features/relatory/widgets/expandable_container.dart';
import 'package:reportpad/app/features/relatory/widgets/formatted_text.dart';
import 'package:reportpad/app/model/image_ftp_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';

import '../../core/ui/helpers/phrase_editing_controller.dart';
import '../../model/scrip_model.dart';

class RelatoryPage extends StatefulWidget {
  final List<ScripModel> scrips;
  final String title;
  final String idSurvey;
  final String phone;
  final String idProcedure;
  final List<ImageFtpModel> imageList;
  const RelatoryPage(
      {super.key,
      required this.scrips,
      required this.title,
      required this.idSurvey,
      required this.phone,
      required this.idProcedure,
      required this.imageList});

  @override
  State<RelatoryPage> createState() => _RelatoryPageState();
}

class _RelatoryPageState extends RelatoryView<RelatoryPage> {
  String result = '';
  late final IRelatoryRepository repository;
  final List<PhraseEditingController> controllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(1, 134, 167, 100),
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(
              20.0,
            ),
            minScale: 0.5,
            maxScale: 4.0, //
            child: FormattedText(
              idSurvey: widget.idSurvey,
              scrips: widget.scrips,
              phone: widget.phone,
              idProcedure: widget.idProcedure,
              onGeneratedText: (text) async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Text(text),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            right: 15,
            bottom: 80,
            child: ExpandableContainer(imageList: widget.imageList),
          ),
        ],
      ),
    );
  }
}
