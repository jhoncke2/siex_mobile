import 'package:flutter/material.dart';
import 'package:siex/app_theme.dart';
import '../../../domain/entities/time_state.dart';
import 'item_header.dart';

class ItemsScrollable<T> extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final List<T> items;
  final String Function(T) getTitleByItem;
  final TimeState? Function(T) getStateByItem;
  final Widget Function(T) createBodyByItem;
  final List<bool> itemsSelection;
  final bool canChangeItemState;
  final Function(int, bool) onChangeSelection;
  final Function(int, TimeState) onChangeItemState;
  ItemsScrollable({
    required this.items,
    required this.getTitleByItem,
    required this.getStateByItem,
    required this.createBodyByItem,
    required this.itemsSelection,
    required this.canChangeItemState,
    required this.onChangeSelection,
    required this.onChangeItemState,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return SizedBox(
      height: dimens.getHeightPercentage(0.575), 
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 5,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: ExpansionPanelList(
            children: ((){
              final List<ExpansionPanel> children = <ExpansionPanel>[];
              for(int index = 0; index < items.length; index++){
                final item = items[index];
                children.add(ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (_, __) => ItemHeader(
                    index: index,
                    title: getTitleByItem(item),
                    currentItemState: getStateByItem(item),
                    enabled: canChangeItemState,
                    onChangeItemState: onChangeItemState
                  ), 
                  body: createBodyByItem(item),
                  isExpanded: itemsSelection[index]
                ));
              }
              return children;
            })(),
            expansionCallback: onChangeSelection,
          ),
        ),
      ),
    );
  }
}