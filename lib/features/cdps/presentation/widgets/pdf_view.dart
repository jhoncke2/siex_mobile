import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_bloc.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import '../../../../app_theme.dart';

class PdfView extends StatelessWidget {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  final File file;
  PdfView({
    Key? key,
    required this.file
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: dimens.getHeightPercentage(0.04),
          width: dimens.getWidthPercentage(0.1),
          child: InkWell(
            onTap: (){
              BlocProvider.of<CdpsBloc>(context).add(BackToCdpsEvent());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: dimens.getHeightPercentage(0.002),
                horizontal: dimens.getWidthPercentage(0.005)
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.secondary,
                size: dimens.normalIconSize,
              ),
            ),
          ),
        ),
        SizedBox(height: dimens.getHeightPercentage(0.01)),
        SizedBox(
          height: dimens.getHeightPercentage(0.73),
          width: dimens.getWidthPercentage(1),
          child: PDFView(
            filePath: file.path,
            defaultPage: 0,
            swipeHorizontal: true,
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            }
          )
        ),
      ],
    );
  }
}