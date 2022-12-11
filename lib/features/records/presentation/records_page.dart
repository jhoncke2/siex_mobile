// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/app_theme.dart';
import 'package:siex/core/presentation/widgets/custom_app_bar.dart';
import 'package:siex/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:siex/features/records/presentation/bloc/records_bloc.dart';
import 'package:siex/features/records/presentation/widgets/records_view.dart';
import 'package:siex/injection_container.dart';
class RecordsPage extends StatelessWidget {
   RecordsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RecordsBloc>(
            create: (_) => sl<RecordsBloc>()
          ),
          BlocProvider<AuthenticationBloc>(
            create: (_) => sl<AuthenticationBloc>()
          )
        ],
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(),
              BlocBuilder<RecordsBloc, RecordsState>(
                builder: (blocContext, blocState){
                  _managePostFrameCallBacks(blocContext, blocState);
                  return ((blocState is OnRecords)?
                    RecordsView():
                    SizedBox(
                      height: dimens.getHeightPercentage(0.7),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }

  void _managePostFrameCallBacks(BuildContext context, RecordsState state){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(state is OnRecordsInitial){
        BlocProvider.of<RecordsBloc>(context).add(LoadNewRecordsEvent());
      }
    });
  }
}