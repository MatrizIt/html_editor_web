import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_web/app/features/relatory/widgets/app_text_field.dart';
import 'package:html_editor_web/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class FormattedText extends StatefulWidget {
  String text;
  final Function(String) onGeneratedText;
  FormattedText({
    super.key,
    required this.text,
    required this.onGeneratedText,
  });

  @override
  State<FormattedText> createState() => _FormattedTextState();
}

class _FormattedTextState extends State<FormattedText> {
  final List<PhraseEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
  }

  void generateText() {
    String text = widget.text;
    for (PhraseEditingController controller in controllers) {
      if (controller.text != "" || controller.defaultValue != null) {
        text = text.replaceFirst(
          controller.phrase,
          controller.text.isEmpty ? controller.defaultValue! : controller.text,
        );
      }
    }
    text = text.replaceAll(RegExp(r"!\*.+\(.*?.*?\)=.*?\*!"), "");
    Modular.to.pushNamed('/result_preview/', arguments: text);
  }

  @override
  Widget build(BuildContext context) {
    //final regex = RegExp(r"\[\=.*?\((.*?)\)\]");
    final regex = RegExp(r"!\*(.*?)\*!");


    final List<InlineSpan> inlineSpans = [];
    int start = 0;

    for (final match
        in regex.allMatches(widget.text.replaceAll("</br>", "\n"))) {
      final phrase = match.group(0);
      final phraseStart = match.start;
      final phraseEnd = match.end;

      if (phrase != null) {
        final phraseCtrl = PhraseEditingController(phrase: phrase);
        controllers.add(phraseCtrl);
        inlineSpans.add(
          WidgetSpan(
            child: HtmlWidget(
              widget.text.substring(start, phraseStart),
            ),
          ),
        );
        inlineSpans.add(
          WidgetSpan(
            child: SizedBox(
              height: 25,
              child: IntrinsicWidth(
                child: AppTextField(
                  phrase: phrase,
                  onChanged: (text) {
                    controllers[controllers.indexOf(phraseCtrl)].text = text;
                  },
                  controller: controllers[controllers.indexOf(phraseCtrl)],
                ),
              ),
            ),
          ),
        );

        start = phraseEnd;
      }
    }

    inlineSpans
        .add(WidgetSpan(child: HtmlWidget(widget.text.substring(start))));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          generateText();
        },
        child: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                height: 1.5,
              ),
              children: inlineSpans,
            ),
          ),
        ),
      ),
    );
  }
}
