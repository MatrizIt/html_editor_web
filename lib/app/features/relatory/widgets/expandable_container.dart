import 'package:flutter/material.dart';
import 'package:reportpad/app/core/ui/extensions/size_extensions.dart';
import 'package:reportpad/app/features/relatory/widgets/image_snapping.dart';

class ExpandableContainer extends StatefulWidget {
  const ExpandableContainer({super.key});

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  double _width = 100;
  double _height = 100;
  double _radius = 10;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Olá Mundo");
        print(isExpanded);
        if (isExpanded) {
          _width = 100;
          _height = 100;
          _radius = 10;
          isExpanded = !isExpanded;
        } else {
          _width = .9.sw;
          _height = 200;
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
            child: Image.asset(
              'assets/images/barber.png',
              fit: BoxFit.cover,
            ),
          ),
          child: ImageSnapping(),
        ),
      ),
    );
  }
}
