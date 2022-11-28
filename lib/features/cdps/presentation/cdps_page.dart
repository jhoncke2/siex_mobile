// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_bloc.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_event.dart';
import 'package:siex/features/cdps/presentation/bloc/cdps_state.dart';
import 'package:siex/features/cdps/presentation/widgets/appbar.dart';
import 'package:siex/features/cdps/presentation/widgets/cdps_view.dart';
import 'package:siex/injection_container.dart';

class CdpsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<CdpsBloc>(
                create: (_) => sl<CdpsBloc>()
              ),
              BlocProvider<AuthenticationBloc>(
                create: (_) => sl<AuthenticationBloc>()
              )
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Appbar(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.03
                  ),
                  width: screenWidth,
                  child: const Center(
                    child: Text(
                      'Siex Autorizaciones',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                BlocBuilder<CdpsBloc, CdpsState>(
                  builder: (blocContext, blocState){
                    _managePostFrameMethods(blocContext, blocState);
                    if(blocState is OnCdps){
                      return CdpsView();
                    }else{
                      return const CircularProgressIndicator();
                    }
                  }
                ),
                Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _managePostFrameMethods(BuildContext context, CdpsState blocState){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(blocState is OnCdpsInit){
        BlocProvider.of<CdpsBloc>(context).add(LoadCdpsEvent());
      }
    });
  }
}