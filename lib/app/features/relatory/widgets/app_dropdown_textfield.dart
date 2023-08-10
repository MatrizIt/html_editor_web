import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDropdownTextfield extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(dynamic option) onSelectOption;
  final String hintText;
  const AppDropdownTextfield({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onSelectOption,
    required this.hintText,
  }) : super(key: key);

  @override
  State<AppDropdownTextfield> createState() => _AppDropdownTextfieldState();
}

class _AppDropdownTextfieldState extends State<AppDropdownTextfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            replacement: Text(
              widget.hintText,
              style: GoogleFonts.inter(
                color: Colors.blueAccent,
                fontSize: 12,
              ),
            ),
            visible:
                widget.selectedOption != null && widget.selectedOption != '',
            child: Text(
              widget.selectedOption!,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: widget.onSelectOption,
            child: const Icon(Icons.arrow_drop_down),
            itemBuilder: (context) =>
                widget.options.map<PopupMenuItem>((option) {
              return PopupMenuItem(
                value: option,
                child: Text(
                  option,
                  style: GoogleFonts.inter(
                    color: widget.selectedOption == option
                        ? Colors.blueAccent
                        : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
