import 'package:flutter/material.dart';
import 'package:praktika/colorpalette.dart';

class DyedCircle extends StatelessWidget {
  final bool isSelected;
  final ColorPalette colorScheme;

  const DyedCircle(
      {super.key, required this.isSelected, required this.colorScheme});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 2,
                color: isSelected ? colorScheme.accent : Colors.transparent)),
        child: Container(
          height: 20,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: colorScheme.accent),
        ),
      );
}
