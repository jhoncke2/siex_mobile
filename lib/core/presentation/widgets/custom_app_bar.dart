import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siex/app_theme.dart';
import '../../../globals.dart';
import '../../../features/authentication/presentation/bloc/authentication_bloc.dart';
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Container(
      height: dimens.appBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: dimens.normalContainerHorizontalPadding
      ),
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow, 
            spreadRadius: 0.01,
            blurRadius: 5,
            offset: Offset(0, 4)
          )
        ],
        color: AppColors.backgroundPrimary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (authContext, authState) {
              _managePostFrameCallBacks(authContext, authState);
              return ((authState is OnLoadingAuthentication)?
                  Container():
                  FloatingActionButton(
                    backgroundColor: AppColors.secondary,
                    mini: true,
                    heroTag: 'logout_button',
                    onPressed: (authState is OnLoadingAuthentication)? 
                      null : 
                      (){
                          BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
                      },
                    child: Icon(
                      Icons.exit_to_app,
                      size: dimens.littleIconSize,
                    )
                  )
              );
            }
          )
        ],
      ),
    );
  }

  void _managePostFrameCallBacks(BuildContext context, AuthenticationState authState){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(authState is OnUnAuthenticated){
        Navigator.of(context).pushReplacementNamed(NavigationRoutes.authentication);
      }
    });
  }
}