import 'package:flutter/material.dart';
import 'package:siex/app_theme.dart';
class UpdateItemsButton extends StatelessWidget {
  final bool isEnabled;
  final Function() onTap;
  final String name;
  const UpdateItemsButton({
    required this.isEnabled,
    required this.onTap,
    required this.name,    
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return TextButton(
      onPressed: isEnabled? onTap : null,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.lightGreen[400]),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: dimens.getWidthPercentage(0.05)
          )
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)
          )
        )
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          color: isEnabled? Colors.black : Colors.grey
        ),
      )
    );
  }
}