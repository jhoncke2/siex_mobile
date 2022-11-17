// ignore_for_file: use_key_in_widget_constructors, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_bloc.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_event.dart';
import 'package:siex/features/budgets/presentation/bloc/budgets_state.dart';
import 'package:siex/features/budgets/presentation/widgets/feature_body.dart';
import 'package:siex/features/budgets/presentation/widgets/feature_header.dart';

class CdpsView extends StatelessWidget{

  final ScrollController _scrollController;
  CdpsView(): 
    _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<BudgetsBloc>(context).state as OnNewCdps;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, screenHeight * 0.005)
                )
              ]
            ),
            child: const Center(
              child: Text(
                'Cdps',
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.575, 
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 5,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: ExpansionPanelList(
                  children: ((){
                    final List<ExpansionPanel> children = <ExpansionPanel>[];
                    for(int index = 0; index < blocState.newCdps.length; index++){
                      final feature = blocState.newCdps[index];
                      children.add(ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (_, __)=>FeatureHeader(
                          index: index, 
                          feature: feature,
                        ), 
                        body: FeatureBody(feature: feature),
                        isExpanded: blocState.featuresSelection[index]
                      ));
                    }
                    return children;
                  })(),
                  expansionCallback: (index, _){
                    BlocProvider.of<BudgetsBloc>(context).add(ChangeFeatureSelectionEvent(index: index));
                  },
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: blocState.canUpdate? (){
              BlocProvider.of<BudgetsBloc>(context).add(UpdateCdpsEvent());
            } : null,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.lightGreen[400]),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05
                )
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)
                )
              )
            ),
            child: Text(
              'Actualizar',
              style: TextStyle(
                fontSize: 15,
                color: blocState.canUpdate? Colors.black : Colors.grey
              ),
            )
          )
        ],
      ),
    );
  }
}