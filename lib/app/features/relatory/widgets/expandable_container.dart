import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:reportpad/app/features/relatory/widgets/image_snapping.dart';
import 'package:reportpad/app/model/image_ftp_model.dart';

class ExpandableContainer extends StatefulWidget {
  final List<ImageFtpModel> imageList;
  const ExpandableContainer({super.key, required this.imageList});

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  double _width = 100;
  double _height = 100;
  double _radius = 10;
  bool isExpanded = false;
  Image? _image;

  _convertImage() {
    setState(() {
      List<int> bytes = base64Decode(widget.imageList[0].bytes);
      _image = Image.memory(Uint8List.fromList(bytes));
    });
  }

  @override
  void initState() {
    super.initState();
    _convertImage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isExpanded) {
          _width = 100;
          _height = 100;
          _radius = 10;
          isExpanded = !isExpanded;
        } else {
          _width = .9.sw;
          _height = 280;
          _radius = 30;
          isExpanded = !isExpanded;
        }
        setState(() {});
      },
      child: AnimatedContainer(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(_radius),
        ),
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Visibility(
          visible: isExpanded,
          replacement: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: widget.imageList[0].nameFile != "No such file"
                ? Image.memory(
                    base64Decode(widget.imageList[0].bytes),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/no-image.jpg",
                    fit: BoxFit.cover,
                  ),
          ),
          child: ImageSnapping(imageList: widget.imageList),
        ),
      ),
    );
  }
}
