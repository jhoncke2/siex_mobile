import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';

import '../../../../core/domain/entities/time_state.dart';

class CdpsEvent{

}

class ChangeCdpSelectionEvent extends CdpsEvent{
  final int index;
  ChangeCdpSelectionEvent({
    required this.index
  });
}

class UpdateSingleCdpEvent extends CdpsEvent{
  final int index;
  final TimeState newState;
  UpdateSingleCdpEvent({
    required this.index, 
    required this.newState
  });
}

class LoadCdpsEvent extends CdpsEvent{

}

class UpdateCdpsEvent extends CdpsEvent{

}

class ChangeCdpsTypeEvent extends CdpsEvent{
  final CdpsType type;
  ChangeCdpsTypeEvent(this.type);
}

class LoadCdpPdfEvent extends CdpsEvent{
  final Cdp cdp;
  LoadCdpPdfEvent(this.cdp);
}

class BackToCdpsEvent extends CdpsEvent{
  
}