import 'package:flutter/material.dart';
import 'package:reportpad/app/features/relatory/view/relatory_view.dart';
import 'package:reportpad/app/features/relatory/widgets/expandable_container.dart';
import 'package:reportpad/app/features/relatory/widgets/formatted_text.dart';

import '../../core/ui/helpers/phrase_editing_controller.dart';
import '../../model/scrip_model.dart';

class RelatoryPage extends StatefulWidget {
  final List<ScripModel> scrips;
  final String title;
  final String idSurvey;
  final String phone;
  final String idProcedure;
  const RelatoryPage(
      {super.key,
      required this.scrips,
      required this.title,
      required this.idSurvey,
      required this.phone,
      required this.idProcedure});

  @override
  State<RelatoryPage> createState() => _RelatoryPageState();
}

class _RelatoryPageState extends RelatoryView<RelatoryPage> {
  String result = '';

  final List<PhraseEditingController> controllers = [];

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
          const Positioned(
            right: 15,
            bottom: 80,
            child: ExpandableContainer(),
          ),
        ],
      ),
    );
  }
}
