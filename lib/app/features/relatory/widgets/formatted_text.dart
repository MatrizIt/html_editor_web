import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:reportpad/app/core/ui/helpers/pdf_helper.dart';
import 'package:reportpad/app/features/relatory/widgets/app_text_field.dart';
import 'package:reportpad/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:reportpad/app/features/relatory/widgets/title_content.dart';
import 'package:reportpad/app/model/teaching_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import '../../../model/scrip_model.dart';

class FormattedText extends StatefulWidget {
  final List<ScripModel> scrips;
  final Function(String) onGeneratedText;
  final String idSurvey;
  const FormattedText({
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
  List<TitleContent> inlineWidgets = [];
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
        for (int selectedTeaching in scrip.selectedTeachings) {
          print(
              "TEACHING: $selectedTeaching, Texto: ${scrip.getTeachingText(selectedTeaching)}");
          text += "${scrip.getTeachingText(selectedTeaching)}</br>";
        }
      }
      final scripsAux = widget.scrips.map<ScripModel?>((s) {
        if (s != scrip) return s;
        return null;
      }).toList();
      for (ScripModel? anotherScrip in scripsAux) {
        anotherScrip?.teachings.forEach((teaching) {
          if (anotherScrip.selectedTeachings
              .contains(anotherScrip.teachings.indexOf(teaching))) {
            teaching.gatilhos?.forEach((gatilho) {
              print("Gatilho dentro do for ${gatilho.idScrip} + ${scrip.id}");
              if (gatilho.idScrip == scrip.id) {
                print("Gatilho add > ${gatilho.teachingText}");
                text += "\n" + gatilho.teachingText;
                print("TEXTO CONTAINS: ${text.contains(gatilho.teachingText)}");
              }
            });
          }
        });
      }
      for (int i = 0; i <= scrip.leading; i++) {
        text += "</br>";
      }
    }
    print("TEXTO: $text");
    return text;
  }

  void generateText() async {
    String text = mountText();

    for (ScripModel scrip in widget.scrips) {
      if (!scrip.isVisible) {
        text = text.replaceAll(scrip.title, "");
        for (int selectedTeaching in scrip.selectedTeachings) {
          text = text.replaceAll(scrip.teachings[selectedTeaching].text, "");
        }
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
      scrip.teachings[newSelectedTeaching].id.toString(),
      widget.idSurvey,
    );
    print("Response data > $resp");
    scrip.changeSelectedTeaching(newSelectedTeaching);
    scrip.teachings[newSelectedTeaching] = resp;
    widget.scrips[scripIndex] = scrip;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    inlineWidgets = [];
    for (ScripModel scrip in widget.scrips) {
      final List<InlineSpan> inlineSpans = [];
      final title = scrip.title;
      var text = "";
      for (int selectedTeaching in scrip.selectedTeachings) {
        print("Recarregando");
        final regex = RegExp(r"!\*(.*?)\*!");
        int start = 0;
        if (scrip.teachings.isNotEmpty) {
          text = scrip.getTeachingText(selectedTeaching);
        } else if (scrip.teachings.isEmpty) {
          text = "Ocorreu um Erro";
        }
        final scripsAux = widget.scrips.map<ScripModel?>((s) {
          if (s != scrip) return s;
          return null;
        }).toList();
        for (ScripModel? anotherScrip in scripsAux) {
          anotherScrip?.teachings.forEach((teaching) {
            if (anotherScrip.selectedTeachings
                .contains(anotherScrip.teachings.indexOf(teaching))) {
              teaching.gatilhos?.forEach((gatilho) {
                if (gatilho.idScrip == scrip.id) {
                  setState(() {
                    text += "\n" + gatilho.teachingText;
                  });
                }
              });
            }
          });
        }
        for (final match in regex.allMatches(
          text.replaceAll("</br>", "\n"),
        )) {
          final phrase = match.group(0);
          final phraseStart = match.start;
          final phraseEnd = match.end;

          if (phrase != null) {
            int? exists;
            PhraseEditingController phraseCtrl;
            for (PhraseEditingController phraseCtrl in controllers) {
              if (phraseCtrl.phrase == phrase &&
                  phraseCtrl.teachingId ==
                      scrip.teachings[selectedTeaching].id) {
                exists = controllers.indexOf(phraseCtrl);
              }
            }
            if (exists == null) {
              phraseCtrl = PhraseEditingController(
                teachingId: scrip.teachings[selectedTeaching].id,
                phrase: phrase,
              );
              controllers.add(phraseCtrl);
            } else {
              phraseCtrl = controllers[exists];
            }
            inlineSpans.add(
              TextSpan(
                text: text
                    .substring(start, phraseStart)
                    .replaceAll("<br>", "\n")
                    .replaceAll("</br>", "\n")
                    .replaceAll("</div>", "\n")
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
                        controller:
                            controllers[controllers.indexOf(phraseCtrl)],
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
      try {
        inlineWidgets.add(
          TitleContent(
            idSurvey: widget.idSurvey,
            idTeaching: (scrip.teachings.firstOrNull?.id).toString(),
            title: title,
            content: inlineSpans,
            isVisible: scrip.isVisible,
            selectedTeachings: scrip.selectedTeachings,
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
            textFinal: text,
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
              child: Column(
                children: inlineWidgets,
              )),
        ),
      ),
    );
  }
}
