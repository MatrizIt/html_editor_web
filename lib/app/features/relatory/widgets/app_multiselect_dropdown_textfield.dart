import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppMultiselectDropdownTextfield extends StatefulWidget {
  final List<String> options;
  final String initialValue;
  final Function(String parsedSelectedOptions) onSelect;
  final String selectedOptions;
  bool isNotNull;
  AppMultiselectDropdownTextfield({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.initialValue,
    required this.onSelect,
    required this.isNotNull,
  });

  @override
  State<AppMultiselectDropdownTextfield> createState() =>
      _AppMultiselectDropdownTextfieldState();
}

class _AppMultiselectDropdownTextfieldState
    extends State<AppMultiselectDropdownTextfield> {
  final _menuKey = GlobalKey<PopupMenuButtonState>();

  String formatListWithAnd(List<String> items) {
    if (items.isEmpty) {
      return "";
    } else if (items.length == 1) {
      return items[0];
    } else if (items.length == 2) {
      return "${items[0]} e ${items[1]}";
    } else {
      String allItemsExceptLast = items.sublist(0, items.length - 1).join(', ');
      String lastItem = items.last;
      return "$allItemsExceptLast e $lastItem";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          final state = _menuKey.currentState;
          state?.showButtonMenu();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              replacement: Text(
                widget.initialValue,
                style: GoogleFonts.inter(
                  color: widget.isNotNull == true ? Colors.red : Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
              ),
              visible: widget.selectedOptions != null &&
                  widget.selectedOptions != '',
              child: Text(
                widget.selectedOptions ?? "",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
            PopupMenuButton(
              key: _menuKey,
              onSelected: (option) {
                final items = <String>[];
                List<String> auxItems = widget.selectedOptions.split(", ");
                for (String item in auxItems) {
                  items.addAll(item.split(" e "));
                }
                items.remove("");
                print("ITEMS: ${items}");

                if (items.contains(option)) {
                  items.remove(option);
                } else {
                  items.add(option);
                }

                String formattedString = formatListWithAnd(items);
                widget.onSelect(formattedString);
                setState(() {});
              },
              child: const Icon(Icons.arrow_drop_down),
              itemBuilder: (context) =>
                  widget.options.map<PopupMenuItem>((option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Icon(
                          widget.selectedOptions?.contains(option) ?? false
                              ? Icons.check_box
                              : Icons.square_outlined,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .025,
                      ),
                      Text(
                        option,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                          ),
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
    );
  }
}
