import 'package:flutter/material.dart';
import 'package:siex/app_theme.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';

class FeatureBody extends StatelessWidget{
  final Cdp feature;
  const FeatureBody({
    required this.feature,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Padding(
      padding: EdgeInsets.only(
        left: dimens.getWidthPercentage(0.04),
        right: dimens.getWidthPercentage(0.04),
        top: dimens.getHeightPercentage(0.0075),
        bottom: dimens.getHeightPercentage(0.015)
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