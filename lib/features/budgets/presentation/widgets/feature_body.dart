import 'package:flutter/material.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';

class FeatureBody extends StatelessWidget{
  final Feature feature;
  const FeatureBody({
    required this.feature,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        top: screenHeight * 0.0075,
        bottom: screenHeight * 0.015
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${feature.price}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black
            ),
          ),
          Text(
            '${feature.date.year}-${feature.date.month}-${feature.date.day}',
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black54
            ),
          ),
        ],
      ),
    );
  }

}