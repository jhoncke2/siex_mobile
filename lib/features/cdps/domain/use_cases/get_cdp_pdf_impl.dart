import 'package:siex/features/cdps/domain/entities/feature.dart';
import 'package:siex/features/cdps/domain/cdps_failures.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:siex/features/cdps/presentation/use_cases/get_cdp_pdf.dart';
import '../../../../core/domain/use_case_error_handler.dart';
import '../cdps_repository.dart';

class GetCdpPdfImpl implements GetCdpPdf{
  final CdpsRepository repository;
  final UseCaseErrorHandler errorHandler;
  const GetCdpPdfImpl({
    required this.repository,
    required this.errorHandler
  });
  
  @override
  Future<Either<CdpsFailure, File>> call(Feature cdp)async{
    return await errorHandler.executeFunction<CdpsFailure, File>(
      () => repository.getCdpPdf(cdp)
    );
  }
}