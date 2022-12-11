// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/app_theme.dart';
import 'package:siex/core/presentation/widgets/custom_app_bar.dart';
import 'package:siex/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:siex/globals.dart';
import 'package:siex/injection_container.dart';

import 'home_button.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Scaffold(
      body: BlocProvider<AuthenticationBloc>(
        create: (_) => sl<AuthenticationBloc>(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(),
              SizedBox(
                height: dimens.getHeightPercentage(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeButton(
                      name: 'Cdps',
                      routeName: NavigationRoutes.cdps,
                    ),
                    SizedBox(
                      height: dimens.getHeightPercentage(0.01),
                    ),
                    HomeButton(
                      name: 'Registros',
                      routeName: NavigationRoutes.records
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}