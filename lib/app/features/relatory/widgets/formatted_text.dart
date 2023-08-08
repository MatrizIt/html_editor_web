import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_web/app/features/relatory/widgets/app_text_field.dart';
import 'package:html_editor_web/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../model/scrip_model.dart';

class FormattedText extends StatefulWidget {
  final List<ScripModel> scrips;
  final String text;
  final Function(String) onGeneratedText;
  FormattedText({
    super.key,
    required this.scrips,
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
    Modular.to.pushNamed(
      '/result_preview/',
      arguments: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> inlineSpans = [];

    for (ScripModel scrip in widget.scrips) {
      inlineSpans.add(
        TextSpan(
          text: '${scrip.title}\n\n',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      final regex = RegExp(r"!\*(.*?)\*!");
      int start = 0;
      final text = scrip.teachings[0].text;
      for (final match in regex.allMatches(
        text.replaceAll("</br>", "\n"),
      )) {
        final phrase = match.group(0);
        final phraseStart = match.start;
        final phraseEnd = match.end;

        if (phrase != null) {
          final phraseCtrl = PhraseEditingController(phrase: phrase);
          controllers.add(phraseCtrl);
          inlineSpans.add(
            TextSpan(
              text: text
                  .substring(start, phraseStart)
                  .replaceAll(RegExp(r"<[^>]+>"), "")
                  .replaceAll("&nbsp;", " "),
            ),
          );
          if (phrase.startsWith("!**")) {
            inlineSpans.add(
              TextSpan(
                text: phrase
                    .replaceAll("!", "")
                    .replaceAll("*", "")
                    .replaceAll("=", ""),
              ),
            );
          } else {
            inlineSpans.add(
              WidgetSpan(
                child: SizedBox(
                  height: 25,
                  child: IntrinsicWidth(
                    child: AppTextField(
                      phrase: phrase,
                      onChanged: (text) {
                        controllers[controllers.indexOf(phraseCtrl)].text =
                            text;
                      },
                      controller: controllers[controllers.indexOf(phraseCtrl)],
                    ),
                  ),
                ),
              ),
            );
          }

          start = phraseEnd;
        }
      }

      inlineSpans.add(
        TextSpan(
          text:
              "${text.substring(start).replaceAll(RegExp(r"<[^>]+>"), "").replaceAll("&nbsp;", " ")}\n\n",
        ),
      );
    }

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
