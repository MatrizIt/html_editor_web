import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ResultPreviewPage extends StatefulWidget {
  final String result;
  const ResultPreviewPage({
    super.key,
    required this.result,
  });

  @override
  State<ResultPreviewPage> createState() => _ResultPreviewPageState();
}

class _ResultPreviewPageState extends State<ResultPreviewPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.result.contains("PROCEDIMENTOS REALIZADOS"));
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
              widget.result,
              renderMode: RenderMode.column,
            ),
          ),
        ),
      ),
    );
  }
}
