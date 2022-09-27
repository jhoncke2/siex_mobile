import 'package:flutter/material.dart';

class ListItem extends StatelessWidget{
  final Widget child;
  const ListItem({
    required this.child,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        bottom: screenHeight * 0.005
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.0125,
        horizontal: screenWidth * 0.035
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 3)
          )
        ]
      ),
      child: child
    );
  }

}