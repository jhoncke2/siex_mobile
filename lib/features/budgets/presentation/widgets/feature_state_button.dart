import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/budgets/domain/entities/feature.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';
import '../bloc/budgets_bloc.dart';

class FeatureStateButton extends StatelessWidget{
  final FeatureState selectionState;
  final int index;
  final Feature feature;
  final double screenWidth;
  final String name;
  const FeatureStateButton({
    required this.selectionState,
    required this.index,
    required this.feature, 
    required this.screenWidth,
    required this.name,
    super.key  
  });
  @override
  Widget build(BuildContext context) {
    final buttonIsLocked = feature.state == selectionState;
    return Column(
      children: [
        FloatingActionButton(
          mini: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: buttonIsLocked? null : (){
            BlocProvider.of<BudgetsBloc>(context).add(UpdateFeatureEvent(index: index, newState: selectionState));
          },
          child: Icon(
            Icons.circle,
            color: buttonIsLocked? Colors.lightGreen : Colors.grey,
            size: screenWidth * 0.03,
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 11.5
          ),
        )
      ],
    );
  }

}