import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_editor_web/app/core/ui/extensions/size_extensions.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ResultPreviewPage extends StatelessWidget {
  final String result;
  const ResultPreviewPage({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Zoom(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: HtmlWidget(
              result,
            ),
          ),
        ),
      ),
    );
  }
}
