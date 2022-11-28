import 'package:flutter/material.dart';
import 'list_item.dart';

//TODO: Actualizar como vista home 
class BudgetsView extends StatelessWidget{
  const BudgetsView({
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.5,
      child: ListView(
        children: [].map(
          (budget) => GestureDetector(
            onTap: budget.completed? null : (){
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