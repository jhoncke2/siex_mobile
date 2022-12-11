import 'package:equatable/equatable.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';

enum CdpsType{
  newType,
  oldType
}

class CdpsGroup extends Equatable{
  final List<Cdp> newCdps;
  final List<Cdp> oldCdps;
  const CdpsGroup({
    required this.newCdps, 
    required this.oldCdps
  });
  @override
  List<Object?> get props => [
    newCdps,
    oldCdps
  ];
}