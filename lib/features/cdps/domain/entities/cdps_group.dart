import 'package:equatable/equatable.dart';
import 'package:siex/features/cdps/domain/entities/feature.dart';

enum CdpsType{
  newType,
  oldType
}

class CdpsGroup extends Equatable{
  final List<Feature> newCdps;
  final List<Feature> oldCdps;
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