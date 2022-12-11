import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/app_theme.dart';
import 'package:siex/features/cdps/domain/entities/cdp.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';

import '../bloc/cdps_bloc.dart';

class CdpBody extends StatelessWidget{
  final Cdp feature;
  const CdpBody({
    required this.feature,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Padding(
      padding: EdgeInsets.only(
        left: dimens.getWidthPercentage(0.04),
        right: dimens.getWidthPercentage(0.04),
        top: dimens.getHeightPercentage(0.0075),
        bottom: dimens.getHeightPercentage(0.015)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${feature.price}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black
            ),
          ),
          Visibility(
            visible: feature.pdfUrl.isNotEmpty,
            child: InkWell(
              onTap: (){
                BlocProvider.of<CdpsBloc>(context).add(LoadCdpPdfEvent(feature));
              },
              child: Icon(
                Icons.picture_as_pdf,
                color: Colors.redAccent,
                size: dimens.littleIconSize,
              ),
            )
          ),
          Text(
            '${feature.date.year}-${feature.date.month}-${feature.date.day}',
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black54
            ),
          ),
        ],
      ),
    );
  }

}