import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:siex/injection_container.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthenticationBloc>(
        create: (_) => sl<AuthenticationBloc>(),
        child: const SafeArea(
          child: Center(
            child: Text('Home Page'),
          ),
        ),
      )
    );
  }
}