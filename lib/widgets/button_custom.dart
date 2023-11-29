import 'package:flutter/material.dart';
import 'package:money_expanse/config/theme.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({super.key, required this.label, required this.onTap, required this.marginHorizontal, });
  final String label;
  final Function onTap;
  final double marginHorizontal;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap();
      },
      style: TextButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      child: Container(
        height: 25,
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}