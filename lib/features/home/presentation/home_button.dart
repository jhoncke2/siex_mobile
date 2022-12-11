import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class HomeButton extends StatelessWidget {
  final String name;
  final String routeName;
  
  const HomeButton({
    required this.name,
    required this.routeName,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return InkWell(
      child: Container(
        width: dimens.getWidthPercentage(0.9),
        padding: EdgeInsets.symmetric(
          vertical: dimens.getHeightPercentage(0.015)
        ),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(0, 3),
              blurRadius: 5,
              spreadRadius: 2
            )
          ]
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: dimens.subtitleTextSize,
              color: AppColors.textPrimaryDark
            ),
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).pushNamed(routeName);
      }
    );
  }
}