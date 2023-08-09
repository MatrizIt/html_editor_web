import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_web/app/core/ui/helpers/pdf_helper.dart';
import 'package:html_editor_web/app/features/relatory/widgets/app_text_field.dart';
import 'package:html_editor_web/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_editor_web/app/features/relatory/widgets/title_content.dart';

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

  void generateText() async{
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
    var path = await PdfHelper().createPDF(text);

    PDFView(
      filePath: path,
    );
    /*Modular.to.pushNamed(
      '/result_preview/',
      arguments: text,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final List<TitleContent> inlineWidget = [];

    for (ScripModel scrip in widget.scrips) {
      final List<InlineSpan> inlineSpans = [];
      final title = Text('${scrip.title}\n',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
        ),);

      final regex = RegExp(r"!\*(.*?)\*!");
      int start = 0;
      var text = "";
      if(scrip.teachings.isNotEmpty){
        text = scrip.teachings[0].text;
      }else if(scrip.teachings.isEmpty){
        text = "Ocorreu um Erro";
      }
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
                  height: 18,
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

      inlineWidget.add(TitleContent(title: title, content: inlineSpans,startActive: widget.scrips.indexOf(scrip) == 0,));
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
          child:Column(
            children: inlineWidget,
          )
        ),
      ),
    );
  }
}
