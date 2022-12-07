// ignore_for_file: use_key_in_widget_constructors, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/app_theme.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_bloc.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_state.dart';
import 'package:siex/features/cdps/presentation/widgets/feature_body.dart';
import 'package:siex/features/cdps/presentation/widgets/feature_header.dart';

class CdpsView extends StatelessWidget{

  final ScrollController _scrollController;
  CdpsView(): 
    _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<CdpsBloc>(context).state as OnShowingCdps;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: blocState is OnOldCdpsSuccess? (){
                  BlocProvider.of<CdpsBloc>(context).add(ChangeCdpsTypeEvent(CdpsType.newType));
                } : null,
                child: Container(
                  width: screenWidth * 0.5,
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
                  child: Center(
                    child: Text(
                      'Cdps nuevos',
                      style: TextStyle(
                        color: blocState is OnNewCdps? AppColors.secondary: AppColors.textPrimary,
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: blocState is OnNewCdps? (){
                  BlocProvider.of<CdpsBloc>(context).add(ChangeCdpsTypeEvent(CdpsType.oldType));
                } : null,
                child: Container(
                  width: screenWidth * 0.5,
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
                  child: Center(
                    child: Text(
                      'Cdps históricos',
                      style: TextStyle(
                        color: blocState is OnOldCdpsSuccess? AppColors.secondary: AppColors.textPrimary,
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              )
            ]
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
                    final currentCdps = (blocState is OnNewCdps)?
                        blocState.cdps.newCdps : 
                        blocState.cdps.oldCdps;
                    for(int index = 0; index < currentCdps.length; index++){
                      final feature = currentCdps[index];
                      children.add(ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (_, __) => FeatureHeader(
                          index: index, 
                          feature: feature,
                          enabled: blocState is OnNewCdps,
                        ), 
                        body: FeatureBody(feature: feature),
                        isExpanded: blocState.featuresSelection[index]
                      ));
                    }
                    return children;
                  })(),
                  expansionCallback: (index, _){
                    BlocProvider.of<CdpsBloc>(context).add(ChangeFeatureSelectionEvent(index: index));
                  },
                ),
              ),
            ),
          ),
          ((blocState is OnNewCdps)? TextButton(
              onPressed: blocState.canUpdateNewCdps? (){
                BlocProvider.of<CdpsBloc>(context).add(UpdateCdpsEvent());
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
                  color: blocState.canUpdateNewCdps? Colors.black : Colors.grey
                ),
              )
            ) : Container()
          )
        ],
      ),
    );
  }
}