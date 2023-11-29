import 'package:flutter/material.dart';
import 'package:money_expanse/config/theme.dart';

class IconCustom extends StatelessWidget {
  const IconCustom({super.key, required this.asset, required this.color,required this.bg});

  final String asset;
  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(18)),
        height: 36,
        width: 36,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            asset, color: color,
          ),
        ));
  }
}
