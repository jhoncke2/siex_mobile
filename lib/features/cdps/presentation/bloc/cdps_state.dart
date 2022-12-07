import 'dart:io';

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


abstract class OnError{
  String get message;
}

class OnLoadingCdpsFailure extends CdpsState implements OnError{
  @override
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

abstract class OnShowingCdps extends OnCdps{
  OnShowingCdps({
    required super.featuresSelection,
    required super.cdps,
    required super.canUpdateNewCdps
  });
}

abstract class OnOldCdps extends OnShowingCdps{
  OnOldCdps({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

class OnOldCdpsSuccess extends OnOldCdps{
  OnOldCdpsSuccess({
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
}

class OnOldCdpsError extends OnOldCdps implements OnError{
  @override
  final String message;
  OnOldCdpsError({
    required this.message,
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps
  });
  @override
  List<Object?> get props => [...super.props, message];
}

abstract class OnNewCdps extends OnShowingCdps{
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

class OnNewCdpsError extends OnNewCdps implements OnError{
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

class OnCdpPdf extends OnCdps{
  final File pdf;
  final CdpsType cdpsType;
  OnCdpPdf({
    required this.pdf,
    required this.cdpsType,
    required super.cdps,
    required super.featuresSelection,
    required super.canUpdateNewCdps,
  });
  @override
  List<Object?> get props => [
    ...super.props, 
    pdf.path,
    cdpsType
  ];
}