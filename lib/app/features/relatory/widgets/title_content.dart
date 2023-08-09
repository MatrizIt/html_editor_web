import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reportpad/app/model/teaching_model.dart';

class TitleContent extends StatefulWidget {
  final Widget title;
  final List<String> teachings;
  final List<InlineSpan> content;
  final bool isVisible;
  final VoidCallback changeVisibility;
  final int selectedTeaching;
  final Function(int selectedTeaching) changeSelectedTeaching;

  const TitleContent({
    super.key,
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: widget.changeVisibility,
                icon: Icon(widget.isVisible == true
                    ? Icons.close_outlined
                    : Icons.refresh)),
            widget.title,
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                onChanged: (selectedTeaching) {
                  widget.changeSelectedTeaching(selectedTeaching as int);
                },
                selectedItemBuilder: (context) {
                  return [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .1,
                    )
                  ];
                },
                items: widget.teachings.map<DropdownMenuItem>((teaching) {
                  return DropdownMenuItem(
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
            ),
          ],
        ),
        AnimatedSwitcher(
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
      ],
    );
  }
}
