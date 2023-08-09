import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleContent extends StatefulWidget {
  final Widget title;
  final List<InlineSpan> content;
  final bool startActive;

  const TitleContent({super.key, required this.title, required this.content,  this.startActive = true});

  @override
  State<TitleContent> createState() => _TitleContentState();
}

class _TitleContentState extends State<TitleContent> {
  bool isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVisible = widget.startActive;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(isVisible == true
                      ? Icons.close_outlined
                      : Icons.refresh)),
              widget.title,
              IconButton(
                  onPressed: () {
                    print("Content > ${widget.content}");
                  }, icon: Icon(Icons.arrow_drop_down_outlined))
            ],
          ),
          isVisible == true
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
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
