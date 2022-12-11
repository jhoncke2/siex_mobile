import 'package:flutter/material.dart';
import 'package:siex/app_theme.dart';

class ItemsTypeChoosingButton extends StatelessWidget {
  final bool isEnabled;
  final Function() onTap;
  final String name;
  const ItemsTypeChoosingButton({
    required this.isEnabled,
    required this.onTap,
    required this.name,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return InkWell(
      onTap: isEnabled? onTap : null,
      child: Container(
        width: dimens.getWidthPercentage(0.5),
        padding: EdgeInsets.symmetric(
          vertical: dimens.getHeightPercentage(0.02)
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: Offset(0, dimens.getHeightPercentage(0.005))
            )
          ]
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: isEnabled? AppColors.textPrimary: Colors.grey,
              fontSize: 17
            ),
          ),
        ),
      ),
    );
  }
}