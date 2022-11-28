import 'package:flutter/material.dart';
import '../../../../app_theme.dart';

class SignInFormField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool onError;
  final String errorMessage;
  const SignInFormField({
    required this.title,
    required this.controller,
    required this.textInputType,
    required this.onError,
    required this.errorMessage,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: dimens.getWidthPercentage(0.05)
          ),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: dimens.normalTextSize
            ),
          ),
        ),
        SizedBox(
          height: dimens.getHeightPercentage(0.01),
        ),
        TextFormField(
          keyboardType: textInputType,
          obscureText: (textInputType == TextInputType.text),
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person_outline,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(dimens.getWidthPercentage(0.11)),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.525),
                width: 3.5
              )
            )
          )
        ),
        Visibility(
          visible: onError,
          child: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: dimens.littleTextSize
            ),
          )  
        )
      ],
    );
  }
}