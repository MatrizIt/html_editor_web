import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reportpad/app/core/ui/helpers/pdf_helper.dart';
import 'package:reportpad/app/features/relatory/widgets/app_text_field.dart';
import 'package:reportpad/app/core/ui/helpers/phrase_editing_controller.dart';
import 'package:reportpad/app/features/relatory/widgets/title_content.dart';
import 'package:reportpad/app/model/teaching_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';
import '../../../core/ui/helpers/scrip_final_text.dart';
import '../../../model/scrip_model.dart';

class FormattedText extends StatefulWidget {
  final List<ScripModel> scrips;
  final Function(String) onGeneratedText;
  final String idSurvey;
  final String phone;
  final String idProcedure;
  const FormattedText({
    super.key,
    required this.scrips,
    required this.onGeneratedText,
    required this.idSurvey,
    required this.phone,
    required this.idProcedure,
  });

  @override
  State<FormattedText> createState() => _FormattedTextState();
}

class _FormattedTextState extends State<FormattedText> {
  final List<PhraseEditingController> controllers = [];
  List<TitleContent> inlineWidgets = [];
  List<TeachingFinalText> teachingFinalTexts = [];
  late final IRelatoryRepository repository;
  bool isNotNull = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    repository = Modular.get<IRelatoryRepository>();
  }

  String mountText() {
    String text = "";

    for (var scrip in widget.scrips) {
      text += "<b>${scrip.title}</b></br>";
      if (scrip.teachings.isNotEmpty) {
        for (int selectedTeaching in scrip.selectedTeachings) {
          text += scrip.getTeachingText(selectedTeaching);
        }
        text += "&nbsp;${scrip.finalText}</br>";
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
                text += "\n${gatilho.teachingText}";
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
    return text;
  }

  void generateText() async {
    String text = mountText();
    var regXP = RegExp(r"\[\[(.*?)\]\]");

    for (ScripModel scrip in widget.scrips) {
      if (!scrip.isVisible) {
        text = text.replaceAll(scrip.title, "");
        for (int selectedTeaching in scrip.selectedTeachings) {
          text = text.replaceAll(scrip.teachings[selectedTeaching].text, "");
        }
      }
    }

    for (PhraseEditingController controller in controllers) {
      text = text.replaceFirst(
        controller.phrase,
        controller.text.isEmpty
            ? controller.defaultValue ?? "!**"
            : controller.text,
      );
    }
    //text = text.replaceAll(RegExp(r"!\*.+\(.*?.*?\)=.*?\*!"), "");

    for (var match in regXP.allMatches(text)) {
      var textMatch = match.group(0);
      print("Match > ${textMatch}");
      if ((textMatch?.contains("!*") ?? false) ||
          (textMatch?.contains("!**") ?? false)) {
        print("Existe > ${textMatch?.contains("!*")}");
        text = text.replaceAll("$textMatch", "");
      }
    }

    for (var match in regXP.allMatches(text)) {
      var textMatch = match.group(0);

      if (textMatch?.contains("[[") ?? false) {
        text = text.replaceAll("[[", "");
        text = text.replaceAll("]]", "");
      }
    }

    text = text.replaceAll(RegExp(r"!\*.*?\*!"), "");
    text = text.replaceAll("!**", "");
    /*var data = await repository.getPreviewReport(widget.phone, int.parse(widget.idProcedure),int.parse(widget.idSurvey),text, false);

    String base64StringFromAPI = data; // Substitua pelo seu base64
    List<int> bytes = base64.decode(base64StringFromAPI.replaceAll('"', ""));

    var directory = await getExternalStorageDirectory();
    String docxFilePath = '${directory?.path}/arquivo.docx';

    try {
      File docxFile = await File(docxFilePath).writeAsBytes(bytes);

      OpenFile.open(docxFile.path.substring(1, docxFile.path.length));
    } catch (e) {
      print(e);
    }*/

    Modular.to.pushNamed(
      '/result_preview/',
      arguments: {
        "result": text,
        "procedure": widget.idProcedure,
        "phone": widget.phone,
        "idSurvey": widget.idSurvey
      },
    );
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

  void changeScripFinalText(int scripIndex, String text) {
    final scrip = widget.scrips[scripIndex];
    scrip.finalText = text;
    widget.scrips[scripIndex] = scrip;
  }

  @override
  Widget build(BuildContext context) {
    inlineWidgets = [];
    bool _isTextFieldValid = true;
    for (ScripModel scrip in widget.scrips) {
      final List<InlineSpan> inlineSpans = [];
      final title = scrip.title;
      var text = "";
      for (int selectedTeaching in scrip.selectedTeachings) {
        final regex = RegExp(r"!\*(.*?)\*!");
        int start = 0;
        if (scrip.teachings.isNotEmpty) {
          text = scrip
              .getTeachingText(selectedTeaching)
              .replaceAll("<br>", "\n")
              .replaceAll("</br>", "\n")
              .replaceAll("&nbsp;", " ")
              .replaceAll("<div>", "")
              .replaceAll("</div>", "\n")
              .replaceAll(RegExp(r"<[^>]+>"), "");
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
        for (int index = 0; index < regex.allMatches(text).length; index++) {
          final match = regex.allMatches(text).toList()[index];
          final phrase = match.group(0);
          final phraseStart = match.start;
          final phraseEnd = match.end;

          if (phrase != null) {
            PhraseEditingController? phraseCtrl;
            for (var controller in controllers) {
              final id = "${scrip.teachings[selectedTeaching].id}$index";
              if (controller.id == id) {
                phraseCtrl = controller;
                break;
              }
            }
            if (phraseCtrl == null) {
              phraseCtrl = PhraseEditingController(
                id: "${scrip.teachings[selectedTeaching].id}$index",
                phrase: phrase,
              );
              controllers.add(phraseCtrl);
            }
            inlineSpans.add(
              TextSpan(text: text.substring(start, phraseStart)),
            );
            if (phrase.startsWith("!**")) {
              //print(phrase);
              inlineSpans.add(
                WidgetSpan(
                  child: SizedBox(
                    height: 20,
                    child: IntrinsicWidth(
                      child: AppTextField(
                        phrase: phrase,
                        onChanged: (text) {
                          final index = controllers.indexOf(phraseCtrl!);
                          final controller = controllers[index];
                          controller.text = text;
                          controllers[index] = controller;
                        },
                        selectedOption:
                            controllers[controllers.indexOf(phraseCtrl)].text,
                        controller:
                            controllers[controllers.indexOf(phraseCtrl)],
                        isNotNull: true,
                      ),
                    ),
                  ),
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
                          final index = controllers.indexOf(phraseCtrl!);
                          final controller = controllers[index];
                          controller.text = text;
                          controllers[index] = controller;
                        },
                        selectedOption:
                            controllers[controllers.indexOf(phraseCtrl)].text,
                        controller:
                            controllers[controllers.indexOf(phraseCtrl)],
                        isNotNull: false,
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
            text: "${text.substring(start)}",
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
              teachings: scrip.teachings,
              changeSelectedTeaching: (selectedTeaching) {
                setState(() {
                  changeSelectedTeaching(
                      widget.scrips.indexOf(scrip), selectedTeaching);
                });
              },
              onChangeFinalText: (text) {
                var scripIndex = widget.scrips.indexOf(scrip);
                changeScripFinalText(scripIndex, text);
              }),
        );
      } catch (e, s) {
        print("ERROR: $e, STACKTRACE: $s");
      }
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 160, 0, 100),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            generateText();
          }
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
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: inlineWidgets,
                ),
              )),
        ),
      ),
    );
  }
}
