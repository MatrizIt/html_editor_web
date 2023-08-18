import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/model/teaching_model.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TitleContent extends StatefulWidget {
  final String idSurvey;
  final String idTeaching;
  final String title;
  final List<TeachingModel> teachings;
  final List<InlineSpan> content;
  final bool isVisible;
  final VoidCallback changeVisibility;
  final List<int> selectedTeachings;
  final Function(int selectedTeaching) changeSelectedTeaching;
  final Function(String text) onChangeFinalText;

  TitleContent({
    super.key,
    required this.idSurvey,
    required this.idTeaching,
    required this.title,
    required this.content,
    required this.isVisible,
    required this.selectedTeachings,
    required this.changeVisibility,
    required this.teachings,
    required this.changeSelectedTeaching,
    required this.onChangeFinalText,
  });

  @override
  State<TitleContent> createState() => _TitleContentState();
}

class _TitleContentState extends State<TitleContent> {
  stt.SpeechToText speech = stt.SpeechToText();
  StreamController<bool> atualizaIconMic = StreamController<bool>.broadcast();
  final TextEditingController _controllerText = TextEditingController();
  bool speechEnabled = false;
  bool isListening = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    bool _expandDescription = false;
    return Column(
      children: [
        Transform(
          transform: Matrix4.translationValues(-8.0, 0.0, 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: widget.changeVisibility,
                  icon: Icon(
                    widget.isVisible == true
                        ? Icons.close_outlined
                        : Icons.refresh_outlined,
                    color: widget.isVisible == true ? Colors.red : Colors.blue,
                  )),
              Text(
                widget.title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              PopupMenuButton(
                child: const Icon(Icons.arrow_drop_down),
                onSelected: (selectedTeaching) {
                  widget.changeSelectedTeaching(selectedTeaching as int);
                },
                itemBuilder: (context) =>
                    widget.teachings.map<PopupMenuItem>((teaching) {
                      return PopupMenuItem(
                        value: widget.teachings.indexOf(teaching),
                        child: Row(
                          children: [
                            Icon(
                              widget.selectedTeachings
                                  .contains(widget.teachings.indexOf(teaching))
                                  ? Icons.check_box
                                  : Icons.square_outlined,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              teaching.name,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(12.0, 0.0, 0.0),
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: widget.isVisible == true
                ? SizedBox(
              width: MediaQuery.sizeOf(context).width / 0.4,
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  children: widget.content,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ),
        widget.isVisible == true
            ? SizedBox(
          height: _controllerText.text.length > 40 ? 70 : 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform(
                transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                child: IconButton(
                  alignment: Alignment.topCenter,
                  onPressed: listen,
                  icon: StreamBuilder<bool>(
                    stream: atualizaIconMic.stream,
                    builder: (context, snapshot) {
                      return Icon(
                        Icons.mic,
                        color: isListening == true
                            ? Colors.red
                            : Colors.black,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.2,
                child: TextField(
                  controller: _controllerText,
                  focusNode: _focusNode,
                  onChanged: (text){
                    widget.onChangeFinalText("$text\n");
                    if(_controllerText.text.length > 40){
                      setState(() {});
                    }
                  },
                  maxLines: _controllerText.text.length > 40 ? 5 : 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),

                ),
              ),
              /*IconButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        icon: const Icon(Icons.check, color: Colors.green))*/
            ],
          ),
        )
            : const SizedBox.shrink(),
      ],
    );
  }

  Future _initSpeech() async {
    speechEnabled = await speech.initialize(
      onStatus: (status) {
        print("STATUS: $status");
      },
      onError: (error) {
        log(error.toString());
      },
      debugLogging: true,
    );
  }

  Future<void> listen() async {
    if (speech.isNotListening) {
      if (speechEnabled) {
        await speech.listen(
          onResult: (result) {
            setState(() {
              _controllerText.text = result.recognizedWords;
              widget.onChangeFinalText("${_controllerText.text}\n");
            });
          },
        );
        isListening = speech.isListening;
        setState(() {});
      } else {
        log("The user has denied the use of speech recognition.");
      }
    } else {
      await speech.stop();
      isListening = speech.isListening;
      setState(() {});
    }
  }
}
