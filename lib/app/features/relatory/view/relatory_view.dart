import 'package:flutter/cupertino.dart';
import 'package:html_editor_web/app/features/relatory/relatory_page.dart';

abstract class RelatoryView<T extends RelatoryPage> extends State<T> {
  String text = '';

  @override
  void initState() {
    super.initState();
    mountText();
  }

  void mountText() {
    for (var scrip in widget.scrips) {
      text += "<b>${scrip.title}</b>";
      if(scrip.teachings.isNotEmpty){
        text += "${scrip.teachings[0].text}";
      }
      text += "Ocorreu um erro";
      for (int i = 0; i <= scrip.leading; i++) {
        text += "</br>";
      }
    }
  }
}
