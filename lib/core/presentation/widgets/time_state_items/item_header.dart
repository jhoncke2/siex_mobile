import 'package:flutter/material.dart';
import '../../../domain/entities/time_state.dart';
import 'item_state_button.dart';

class ItemHeader extends StatelessWidget{
  final int index;
  final String title;
  final TimeState? currentItemState;
  final bool enabled;
  final Function(int, TimeState) onChangeItemState;
  const ItemHeader({
    required this.index,
    required this.title,
    required this.currentItemState,
    required this.enabled,
    required this.onChangeItemState,
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
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black
              ),
            ),
          ),
          ItemStateButton(
            buttonSelectionState: TimeState.permitted,
            currentItemState: currentItemState,
            index: index,
            screenWidth: screenWidth, 
            name: 'Aceptar',
            enabled: enabled,
            onChangeItemState: onChangeItemState
          ),
          ItemStateButton(
            buttonSelectionState: TimeState.denied,
            currentItemState: currentItemState,
            index: index,
            screenWidth: screenWidth, 
            name: 'Denegar',
            enabled: enabled,
            onChangeItemState: onChangeItemState
          ),
          ItemStateButton(
            buttonSelectionState: TimeState.returned,
            currentItemState: currentItemState,
            index: index,
            screenWidth: screenWidth, 
            name: 'Devolver',
            enabled: enabled,
            onChangeItemState: onChangeItemState
          )
        ],
      ),
    );
  }

}