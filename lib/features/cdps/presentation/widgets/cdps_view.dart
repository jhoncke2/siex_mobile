// ignore_for_file: use_key_in_widget_constructors, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/app_theme.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_bloc.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_state.dart';
import 'package:siex/features/cdps/presentation/widgets/cdp_body.dart';
import 'package:siex/core/presentation/widgets/time_state_items/update_items_button.dart';
import '../../../../core/presentation/widgets/time_state_items/items_scrollable.dart';
import '../../../../core/presentation/widgets/time_state_items/items_type_choosing_button.dart';

class CdpsView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<CdpsBloc>(context).state as OnCdps;
    final dimens = AppDimens();
    return SizedBox(
      height: dimens.getHeightPercentage(0.75),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ItemsTypeChoosingButton(
                isEnabled: blocState is OnOldCdps,
                onTap: (){
                  BlocProvider.of<CdpsBloc>(context).add(ChangeCdpsTypeEvent(CdpsType.newType));
                },
                name: 'Cdps nuevos',
              ),
              ItemsTypeChoosingButton(
                isEnabled: blocState is OnNewCdps,
                onTap: (){
                  BlocProvider.of<CdpsBloc>(context).add(ChangeCdpsTypeEvent(CdpsType.oldType));
                },
                name: 'Cdps históricos',
              )
            ]
          ),
          ItemsScrollable<Cdp>(
            items: ( 
              (blocState is OnNewCdps)?
                blocState.cdps.newCdps : 
                blocState.cdps.oldCdps
            ),
            getTitleByItem: (item) => item.name,
            getStateByItem: (item) => item.state,
            createBodyByItem: (item) => CdpBody(feature: item),
            itemsSelection: blocState.featuresSelection,
            canChangeItemState: blocState is OnNewCdps,
            onChangeSelection: (index, _){
              BlocProvider.of<CdpsBloc>(context).add(ChangeFeatureSelectionEvent(index: index));
            },
            onChangeItemState: (index, newState){
              BlocProvider.of<CdpsBloc>(context).add(UpdateFeatureEvent(
                index: index,
                newState: newState
              ));
            },
          ),
          ((blocState is OnNewCdps)? UpdateItemsButton(
              isEnabled: blocState.canUpdateNewCdps,
              onTap: (){
                BlocProvider.of<CdpsBloc>(context).add(UpdateCdpsEvent());
              },
              name: 'Actualizar'
            ) : Container()
          )
        ],
      ),
    );
  }
}