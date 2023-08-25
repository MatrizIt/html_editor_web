import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reportpad/app/model/image_ftp_model.dart';

class ImageSnapping extends StatefulWidget {
  final bool favorite;
  final List<ImageFtpModel> imageList;
  const ImageSnapping({super.key, required this.imageList}) : favorite = false;

  const ImageSnapping.favorite({super.key, required this.imageList})
      : favorite = true;

  @override
  State<ImageSnapping> createState() => _ImageSnappingState();
}

class _ImageSnappingState extends State<ImageSnapping> {
  final imagesViewCtrl = PageController();
  int selectedImg = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .35.sh,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: imagesViewCtrl,
            onPageChanged: (value) {
              setState(() {
                selectedImg = value;
              });
            },
            itemCount: widget.imageList.isEmpty ? 1 : widget.imageList.length,
            itemBuilder: (context, index) {
              return widget.imageList[0].nameFile != "No such file"
                  ? Image.memory(
                      base64Decode(widget.imageList[index].bytes),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/no-image.jpg",
                      fit: BoxFit.cover,
                    );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 5,
                  );
                },
                itemCount: widget.imageList.isEmpty ? 1 : widget.imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(
                            0,
                            3,
                          ), // changes position of shadow
                        ),
                      ],
                      color: index == selectedImg
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
