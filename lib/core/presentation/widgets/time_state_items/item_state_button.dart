import 'package:flutter/material.dart';
import '../../../domain/entities/time_state.dart';

class ItemStateButton extends StatelessWidget{
  final TimeState buttonSelectionState;
  final TimeState? currentItemState;
  final int index;
  final double screenWidth;
  final String name;
  final bool enabled;
  final Function(int, TimeState) onChangeItemState;
  const ItemStateButton({
    required this.buttonSelectionState,
    required this.currentItemState,
    required this.index,
    required this.screenWidth,
    required this.name,
    required this.enabled,
    required this.onChangeItemState,
    super.key  
  });
  @override
  Widget build(BuildContext context) {
    final buttonIsSelected = currentItemState == buttonSelectionState;
    final buttonIsLocked = !enabled || buttonIsSelected;
    return Column(
      children: [
        FloatingActionButton(
          heroTag: '${index}_$name',
          mini: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: buttonIsLocked? null : () => onChangeItemState(index, buttonSelectionState),
          child: Icon(
            Icons.circle,
            color: buttonIsSelected? Colors.lightGreen : Colors.grey,
            size: screenWidth * 0.03,
          )
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 11.5
          ),
        )
      ]
    );
  }
}