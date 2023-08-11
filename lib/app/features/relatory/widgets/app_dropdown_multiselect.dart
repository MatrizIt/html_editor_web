import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMultiselectDropDown extends StatefulWidget {
  final Function(List<String>) selectedList;
  final List<String> listOFStrings;

  CustomMultiselectDropDown({
    required this.selectedList,
    required this.listOFStrings,
  });

  @override
  createState() {
    return new _CustomMultiselectDropDownState();
  }
}

class _CustomMultiselectDropDownState extends State<CustomMultiselectDropDown> {
  List<String> listOFSelectedItem = [];
  String selectedText = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: ExpansionTile(
        iconColor: Colors.grey,
        title: const Icon(Icons.arrow_drop_down),
        children: <Widget>[
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.listOFStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: _ViewItem(
                  item: widget.listOFStrings[index],
                  selected: (val) {
                    selectedText = val;
                    if (listOFSelectedItem.contains(val)) {
                      listOFSelectedItem.remove(val);
                    } else {
                      listOFSelectedItem.add(val);
                    }
                    widget.selectedList(listOFSelectedItem);
                    setState(() {});
                  },
                  itemSelected: listOFSelectedItem.contains(
                    widget.listOFStrings[index],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  String item;
  bool itemSelected;
  final Function(String) selected;

  _ViewItem(
      {required this.item, required this.itemSelected, required this.selected});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: itemSelected,
            onChanged: (val) {
              selected(item);
            },
            activeColor: Colors.blue,
          ),
        ),
        SizedBox(
          width: size.width * .025,
        ),
        Text(
          item,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 17.0,
            ),
          ),
        ),
      ],
    );
  }
}
