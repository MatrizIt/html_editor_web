import 'package:flutter/material.dart';
import 'package:html_editor_web/app/features/relatory/view/relatory_view.dart';
import 'package:html_editor_web/app/features/relatory/widgets/formatted_text.dart';

import '../../core/ui/helpers/phrase_editing_controller.dart';
import '../../model/scrip_model.dart';

class RelatoryPage extends StatefulWidget {
  final List<ScripModel> scrips;
  final String title;
  const RelatoryPage({
    super.key,
    required this.scrips, required this.title
  });

  @override
  State<RelatoryPage> createState() => _RelatoryPageState();
}

class _RelatoryPageState extends RelatoryView<RelatoryPage> {
  String result = '';

  final List<PhraseEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(
          20.0,
        ),
        minScale: 0.5,
        maxScale: 4.0, //
        child: FormattedText(
          scrips: widget.scrips,
          text: text,
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
    );
  }
}
