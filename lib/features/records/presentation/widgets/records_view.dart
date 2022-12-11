import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/records/domain/entities/record.dart';
import 'package:siex/features/records/presentation/bloc/records_bloc.dart';
import 'package:siex/features/records/presentation/widgets/record_body.dart';
import '../../../../app_theme.dart';
import '../../../../core/presentation/widgets/time_state_items/items_scrollable.dart';
import '../../../../core/presentation/widgets/time_state_items/items_type_choosing_button.dart';
import '../../../../core/presentation/widgets/time_state_items/update_items_button.dart';

class RecordsView extends StatelessWidget {
  const RecordsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<RecordsBloc>(context).state as OnRecords;
    final dimens = AppDimens();
    return SizedBox(
      height: dimens.getHeightPercentage(0.75),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ItemsTypeChoosingButton(
                isEnabled: blocState is OnOldRecords,
                onTap: (){
                  BlocProvider.of<RecordsBloc>(context).add(LoadNewRecordsEvent());
                },
                name: 'Registros nuevos',
              ),
              ItemsTypeChoosingButton(
                isEnabled: blocState is OnNewRecords,
                onTap: (){
                  BlocProvider.of<RecordsBloc>(context).add(LoadOldRecordsEvent());
                },
                name: 'Registros históricos',
              )
            ]
          ),
          Expanded(
            child: ItemsScrollable<Record>(
              items: blocState.records,
              getTitleByItem: (item) => item.name,
              getStateByItem: (item) => item.state,
              createBodyByItem: (item) => RecordBody(record: item),
              itemsSelection: blocState.recordsSelection,
              canChangeItemState: blocState is OnNewRecords,
              onChangeSelection: (index, _){
                BlocProvider.of<RecordsBloc>(context).add(ChangeRecordsSelectionEvent(index: index));
              },
              onChangeItemState: (index, newState){
                BlocProvider.of<RecordsBloc>(context).add(UpdateRecordStateEvent(
                  index: index, 
                  newState: newState
                ));
              }
            ),
          ),
          ((blocState is OnNewRecords)? UpdateItemsButton(
              isEnabled: blocState.canUpdateRecords,
              onTap: (){
                BlocProvider.of<RecordsBloc>(context).add(UpdateNewRecordsEvent());
              },
              name: 'Actualizar'
            ) : Container()
          )
        ],
      ),
    );
  }
}