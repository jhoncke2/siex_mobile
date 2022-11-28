import 'package:equatable/equatable.dart';
import 'package:siex/features/cdps/domain/entities/cdps_group.dart';

abstract class CdpsState extends Equatable{
  @override
  List<Object?> get props => [runtimeType];
}
class OnCdpsInit extends CdpsState{

}
class OnLoadingCdps extends CdpsState{

}

class OnLoadingCdpsFailure extends CdpsState{
  final String message;
  OnLoadingCdpsFailure({
    required this.message
  });
  @override
  List<Object?> get props => [message];
}

abstract class OnCdps extends CdpsState{
  final CdpsGroup cdps;
  final List<bool> featuresSelection;
  final bool canUpdateNewCdps;
  OnCdps({
    required this.featuresSelection,
    required this.cdps,
    required this.canUpdateNewCdps
  });
  @override
  List<Object?> get props => [
    ...super.props, 
    featuresSelection,
    cdps,
    canUpdateNewCdps
  ];
}

class OnOldCdps extends OnCdps{
  OnOldCdps({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

abstract class OnNewCdps extends OnCdps{
  OnNewCdps({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

class OnNewCdpsSuccess extends OnNewCdps{
  OnNewCdpsSuccess({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

class OnNewCdpsError extends OnNewCdps{
  final String message;
  OnNewCdpsError({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps,
    required this.message
  });
  @override
  List<Object?> get props => [...super.props, message];
}