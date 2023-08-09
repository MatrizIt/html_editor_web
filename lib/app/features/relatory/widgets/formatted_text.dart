import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/core/ui/helpers/pdf_helper.dart';
import 'package:reportpad/app/features/relatory/widgets/app_text_field.dart';
import 'package:reportpad/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:reportpad/app/features/relatory/widgets/title_content.dart';

import '../../../core/ui/helpers/phrase_editing_controller.dart';
import '../../../model/scrip_model.dart';
import 'app_text_field.dart';

class FormattedText extends StatefulWidget {
  final List<ScripModel> scrips;
  final Function(String) onGeneratedText;
  FormattedText({
    super.key,
    required this.scrips,
    required this.onGeneratedText,
  });

  @override
  State<FormattedText> createState() => _FormattedTextState();
}

class _FormattedTextState extends State<FormattedText> {
  final List<PhraseEditingController> controllers = [];
  final List<TitleContent> inlineWidgets = [];

  @override
  void initState() {
    super.initState();
    changeScripVisibility(0);
  }

  String mountText() {
    String text = "";

    for (var scrip in widget.scrips) {
      text += "<b>${scrip.title}</b>";
      if (scrip.teachings.isNotEmpty) {
        text += scrip.selectedTeachingText;
      }
      text += "Ocorreu um erro";
      for (int i = 0; i <= scrip.leading; i++) {
        text += "</br>";
      }
    }
    return text;
  }

  void generateText() async {
    String text = mountText();

    for (ScripModel scrip in widget.scrips) {
      if (!scrip.isVisible) {
        text = text.replaceAll(scrip.title, "");
        text = text.replaceAll(scrip.teachings[0].text, "");
      }
    }

    for (PhraseEditingController controller in controllers) {
      if (controller.text != "" || controller.defaultValue != null) {
        text = text.replaceFirst(
          controller.phrase,
          controller.text.isEmpty ? controller.defaultValue! : controller.text,
        );
      }
    }
    text = text.replaceAll(RegExp(r"!\*.+\(.*?.*?\)=.*?\*!"), "");
    text = text.replaceAll("Ocorreu um erro", "");
    var path = await PdfHelper().createPDF(text);
    final ctxt = context;

    await showDialog(
      context: ctxt,
      builder: (context) {
        return PDFView(
          filePath: path,
        );
      },
    );
    /*Modular.to.pushNamed(
      '/result_preview/',
      arguments: text,
    );*/
  }

  void changeScripVisibility(int index) {
    final scrip = widget.scrips[index];
    scrip.changeVisibility();
    widget.scrips[index] = scrip;
  }

  void changeSelectedTeaching(int scripIndex, int newSelectedTeaching) {
    print("NOVO INDEX $newSelectedTeaching da teaching $scripIndex");
    final scrip = widget.scrips[scripIndex];
    scrip.changeSelectedTeaching(newSelectedTeaching);
    widget.scrips[scripIndex] = scrip;
  }

  @override
  Widget build(BuildContext context) {
    inlineWidgets.removeWhere((item) => true);
    for (ScripModel scrip in widget.scrips) {
      final List<InlineSpan> inlineSpans = [];
      final title = Text(
        '${scrip.title}\n',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
        ),
      );

      final regex = RegExp(r"!\*(.*?)\*!");
      int start = 0;
      var text = "";
      if (scrip.teachings.isNotEmpty) {
        text = scrip.selectedTeachingText;
      } else if (scrip.teachings.isEmpty) {
        text = "Ocorreu um Erro";
      }
      for (final match in regex.allMatches(
        text.replaceAll("</br>", "\n"),
      )) {
        final phrase = match.group(0);
        final phraseStart = match.start;
        final phraseEnd = match.end;

        if (phrase != null) {
          final phraseCtrl = PhraseEditingController(
            phrase: phrase,
          );
          controllers.add(phraseCtrl);
          inlineSpans.add(
            TextSpan(
              text: text
                  .substring(start, phraseStart)
                  .replaceAll("<br>", "\n")
                  .replaceAll("</br>", "\n")
                  .replaceAll("&nbsp;", " ")
                  .replaceAll(RegExp(r"<[^>]+>"), "")
                  ,
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

      inlineWidgets.add(
        TitleContent(
          title: title,
          content: inlineSpans,
          isVisible: scrip.isVisible,
          selectedTeaching: scrip.selectedTeaching,
          changeVisibility: () {
            setState(() {
              changeScripVisibility(widget.scrips.indexOf(scrip));
            });
          },
          teachings:
              scrip.teachings.map<String>((teaching) => teaching.name).toList(),
          changeSelectedTeaching: (selectedTeaching) {
            setState(() {
              changeSelectedTeaching(
                  widget.scrips.indexOf(scrip), selectedTeaching);
            });
          },
        ),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 160, 0, 100),
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
            child: Column(
              children: inlineWidgets,
            )),
      ),
    );
  }
}
