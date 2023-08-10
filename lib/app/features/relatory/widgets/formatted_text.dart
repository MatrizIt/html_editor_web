import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/core/ui/helpers/pdf_helper.dart';
import 'package:reportpad/app/features/relatory/widgets/app_text_field.dart';
import 'package:reportpad/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:reportpad/app/features/relatory/widgets/title_content.dart';
import 'package:reportpad/app/model/teaching_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';

import '../../../core/ui/helpers/phrase_editing_controller.dart';
import '../../../model/scrip_model.dart';
import 'app_text_field.dart';

class FormattedText extends StatefulWidget {
  final List<ScripModel> scrips;
  final Function(String) onGeneratedText;
  final String idSurvey;
  FormattedText({
    super.key,
    required this.scrips,
    required this.onGeneratedText,
    required this.idSurvey,
  });

  @override
  State<FormattedText> createState() => _FormattedTextState();
}

class _FormattedTextState extends State<FormattedText> {
  final List<PhraseEditingController> controllers = [];
  final List<TitleContent> inlineWidgets = [];
  late final IRelatoryRepository repository;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<IRelatoryRepository>();
  }

  String mountText() {
    String text = "";

    for (var scrip in widget.scrips) {
      text += "<b>${scrip.title}</b>";
      if (scrip.teachings.isNotEmpty) {
        text += scrip.selectedTeachingText;
      }
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

  Future<TeachingModel> getTeaching(String idTeaching, String idSurvey) async {
    final newTeaching = await repository.getTeachings(idTeaching, idSurvey);
    return newTeaching;
  }

  void changeSelectedTeaching(int scripIndex, int newSelectedTeaching) async {
    print("NOVO INDEX $newSelectedTeaching da teaching $scripIndex");
    final scrip = widget.scrips[scripIndex];
    var resp = await getTeaching(
        scrip.teachings[newSelectedTeaching].id.toString(), widget.idSurvey);
    print("Response data > $resp");
    scrip.changeSelectedTeaching(newSelectedTeaching);
    setState(() {
      scrip.teachings[newSelectedTeaching].text = resp.text;
    });
    widget.scrips[scripIndex] = scrip;
  }

  @override
  Widget build(BuildContext context) {
    inlineWidgets.removeWhere((item) => true);
    for (ScripModel scrip in widget.scrips) {
      final List<InlineSpan> inlineSpans = [];
      final title = scrip.title;

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
                  .replaceAll(RegExp(r"<[^>]+>"), ""),
            ),
          );
          if (phrase.startsWith("!**")) {
            //print(phrase);
            inlineSpans.add(
              TextSpan(text: phrase),
            );
          } else {
            print(phrase);
            inlineSpans.add(
              WidgetSpan(
                child: SizedBox(
                  height: 18,
                  child: IntrinsicWidth(
                    child: AppTextField(
                      phrase: phrase,
                      onChanged: (text) {
                        final index = controllers.indexOf(phraseCtrl);
                        final controller = controllers[index];
                        controller.text = text;
                        controllers[index] = controller;
                      },
                      selectedOption:
                          controllers[controllers.indexOf(phraseCtrl)].text,
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
      try {
        inlineWidgets.add(
          TitleContent(
            idSurvey: widget.idSurvey,
            idTeaching: (scrip.teachings.firstOrNull?.id).toString(),
            title: title,
            content: inlineSpans,
            isVisible: scrip.isVisible,
            selectedTeaching: scrip.selectedTeaching,
            changeVisibility: () {
              setState(() {
                changeScripVisibility(widget.scrips.indexOf(scrip));
              });
            },
            teachings: scrip.teachings
                .map<String>((teaching) => teaching.name)
                .toList(),
            changeSelectedTeaching: (selectedTeaching) {
              setState(() {
                changeSelectedTeaching(
                    widget.scrips.indexOf(scrip), selectedTeaching);
              });
            },
          ),
        );
      } catch (e, s) {
        print("ERROR: $e, STACKTRACE: $s");
      }
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 160, 0, 100),
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
