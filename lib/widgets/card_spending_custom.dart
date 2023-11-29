import 'package:flutter/material.dart';
import 'package:money_expanse/config/theme.dart';
import 'package:money_expanse/widgets/icon_custom.dart';

class SpendingCardCustom extends StatelessWidget {
  const SpendingCardCustom({super.key, required this.category, required this.asset, required this.bg, required this.color, required this.spend, required this.type});

  final String type;
  final String category;
  final String asset;
  final Color bg;
  final Color color;
  final String spend;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 67,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 2.5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             IconCustom(
              asset: asset,
              color: color,
              bg: bg,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                category,
                style: greyTextStyle.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              spend,
              style: blackTextStyle.copyWith(
                  fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
