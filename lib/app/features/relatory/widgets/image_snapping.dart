import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageSnapping extends StatefulWidget {
  final bool favorite;
  const ImageSnapping({super.key}) : favorite = false;

  const ImageSnapping.favorite({super.key}) : favorite = true;

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
            itemCount: 5,
            itemBuilder: (context, index) {
              return Image.asset(
                'assets/images/barber.png',
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
                itemCount: 5,
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
