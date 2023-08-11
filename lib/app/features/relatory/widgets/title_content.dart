import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/features/relatory/widgets/app_text_field.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TitleContent extends StatefulWidget {
  final String idSurvey;
  final String idTeaching;
  final String title;
  final List<String> teachings;
  final List<InlineSpan> content;
  final bool isVisible;
  final VoidCallback changeVisibility;
  final int selectedTeaching;
  final Function(int selectedTeaching) changeSelectedTeaching;

  const TitleContent({
    super.key,
    required this.idSurvey,
    required this.idTeaching,
    required this.title,
    required this.content,
    required this.isVisible,
    required this.selectedTeaching,
    required this.changeVisibility,
    required this.teachings,
    required this.changeSelectedTeaching,
  });

  @override
  State<TitleContent> createState() => _TitleContentState();
}

class _TitleContentState extends State<TitleContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StreamController<bool> atualizaIconMic = StreamController<bool>.broadcast();
    final TextEditingController _controllerText = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform(
          transform: Matrix4.translationValues(-12.0, 0.0, 0.0),
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
                    child: Text(
                      teaching,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: widget.selectedTeaching ==
                                widget.teachings.indexOf(teaching)
                            ? Colors.blueAccent
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, -12.0, 0.0),
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: widget.isVisible == true
                ? RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      children: widget.content,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(-15.0, -45.0, 0.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  stt.SpeechToText speech = stt.SpeechToText();

                  bool available = await speech.initialize(
                      onStatus: (status) {
                        log(status);
                      },
                      onError: (error) {
                        log(error.toString());
                      },
                      debugLogging: true);

                  if (available) {
                    atualizaIconMic.add(speech.isListening);

                    speech.listen(
                      onResult: (result) {
                        _controllerText.text = result.recognizedWords;
                      },
                    );

                    atualizaIconMic.add(speech.isListening);
                  } else {
                    log("The user has denied the use of speech recognition.");
                  }
                },
                icon: StreamBuilder<bool>(
                  stream: atualizaIconMic.stream,
                  builder: (context, snapshot) {
                    return Icon(
                      Icons.mic,
                      color: snapshot.data == false ? Colors.red : Colors.black,
                    );
                  },
                ),
              ),
              Container(
                width: 200,
                  child: TextField(
                controller: _controllerText, onChanged: (value){
                  
                  },
              ))
            ],
          ),
        ),
      ],
    );
  }
}
