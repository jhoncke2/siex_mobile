import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/budgets/domain/entities/budget.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';

import 'list_item.dart';

class BudgetsView extends StatelessWidget{
  final List<Budget> budgets;
  const BudgetsView({
    required this.budgets,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.5,
      child: ListView(
        children: budgets.map(
          (budget) => GestureDetector(
            onTap: budget.completed? null : (){
              BlocProvider.of<BudgetsBloc>(context).add(SelectBudgetEvent(budget));
            },
            child: ListItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    budget.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.0375
                    )
                  ),
                  Container(
                    height: screenHeight * 0.0075,
                    width: screenHeight * 0.0075,
                    decoration: BoxDecoration(
                      color: (budget.completed)? Colors.grey
                                              : Colors.lightGreen
                    )
                  )
                ],
              ),
            ),
          )
        ).toList(),
      ),
    );
  }

}