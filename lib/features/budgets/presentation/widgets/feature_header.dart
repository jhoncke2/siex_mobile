import 'package:flutter/material.dart';
import '../../domain/entities/feature.dart';
import 'feature_state_button.dart';

class FeatureHeader extends StatelessWidget{
  final int index;
  final Feature feature;
  final bool enabled;
  const FeatureHeader({
    required this.index,
    required this.feature,
    required this.enabled,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.025,
        right: screenWidth * 0.015,
        top: screenHeight * 0.015,
        bottom: screenHeight * 0.015
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * 0.28,
            child: Text(
              feature.name,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black
              ),
            ),
          ),
          FeatureStateButton(
            selectionState: FeatureState.Permitted,
            index: index,
            feature: feature,
            screenWidth: screenWidth, 
            name: 'Aceptar',
            enabled: enabled,
          ),
          FeatureStateButton(
            selectionState: FeatureState.Denied,
            index: index,
            feature: feature,
            screenWidth: screenWidth, 
            name: 'Denegar',
            enabled: enabled,
          ),
          FeatureStateButton(
            selectionState: FeatureState.Returned,
            index: index,
            feature: feature,
            screenWidth: screenWidth, 
            name: 'Devolver',
            enabled: enabled,
          )
        ],
      ),
    );
  }

}