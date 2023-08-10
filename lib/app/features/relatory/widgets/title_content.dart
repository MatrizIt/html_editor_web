import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/model/teaching_model.dart';
import 'package:reportpad/app/repository/relatory/i_relatory_repository.dart';

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
              )
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
      ],
    );
  }
}
