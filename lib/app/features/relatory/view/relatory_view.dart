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
      text += "<b>${scrip.title}</b>\n";
      text += "${scrip.teachings[0].text}\n\n";
      for (int i = 0; i <= scrip.leading; i++) {
        text += "</br>";
      }
    }
  }
}
