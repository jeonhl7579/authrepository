import 'package:fb_auth_provider/pages/singin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_provider.dart';
import '../providers/auth/auth_state.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static const String routeNma='/';

  @override
  Widget build(BuildContext context) {
    final authState=context.watch<AuthProvider>().state;

    if(authState.authStatus==AuthStatus.authenticated){
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context,HomePage.routeName);
      });
    }else if(authState.authStatus==AuthStatus.unauthenticated){
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context,SigninPage.routeName);
      });
    }
    return Scaffold(
      body:Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
