import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'colorpalette.dart';
import 'constants.dart';
import 'dyedcircle.dart';

class ThemePickerWidget extends StatefulWidget {
  final void Function(ColorPalette) callback;
  const ThemePickerWidget(this.callback, {super.key});

  @override
  State<StatefulWidget> createState() => _ThemePickerWidgetState();
}

class _ThemePickerWidgetState extends State<ThemePickerWidget> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => Center(
        child: Material(
          type: MaterialType.circle,
          color: Colors.white,
          child: CircleList(
            origin: const Offset(0, 0),
            outerRadius: 100,
            children: List.generate(
              6,
              (index) => InkWell(
                onTap: () {
                  setState(() => selected = index);
                  widget.callback(Constants.colorSchemes[index]);
                },
                child: DyedCircle(
                    colorScheme: Constants.colorSchemes[index],
                    isSelected: selected == index),
              ),
            ),
          ),
        ),
      );
}
