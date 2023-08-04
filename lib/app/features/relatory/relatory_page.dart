import 'package:flutter/material.dart';
import 'package:html_editor_web/app/features/relatory/view/relatory_view.dart';
import 'package:html_editor_web/app/features/relatory/widgets/formatted_text.dart';

import '../../core/ui/helpers/phrase_editing_controller.dart';
import '../../model/scrip_model.dart';

class RelatoryPage extends StatefulWidget {
  final List<ScripModel> scrips;
  const RelatoryPage({
    super.key,
    required this.scrips,
  });

  @override
  State<RelatoryPage> createState() => _RelatoryPageState();
}

class _RelatoryPageState extends RelatoryView<RelatoryPage> {
  String result = '';

  @override
  void initState() {
    super.initState();
    widget.scrips.forEach(print);
  }

  final List<PhraseEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(
          20.0,
        ),
        minScale: 0.5,
        maxScale: 4.0, //
        child: FormattedText(
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
