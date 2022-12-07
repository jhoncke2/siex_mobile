import 'package:siex/features/cdps/domain/entities/cdps_group.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';

class CdpsEvent{

}

class ChangeFeatureSelectionEvent extends CdpsEvent{
  final int index;
  ChangeFeatureSelectionEvent({
    required this.index
  });
}

class UpdateFeatureEvent extends CdpsEvent{
  final int index;
  final FeatureState newState;
  UpdateFeatureEvent({
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
  final Feature cdp;
  LoadCdpPdfEvent(this.cdp);
}

class BackToCdpsEvent extends CdpsEvent{
  
}