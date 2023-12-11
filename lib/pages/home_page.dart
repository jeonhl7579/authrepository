import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName="/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_)=>false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app),onPressed: (){
              context.read<AuthProvider>().signout();
            },),
            IconButton(icon: Icon(Icons.settings),onPressed: (){},),
          ],
        ),
        body: Center(child: Text("Home"),),
      ),
    );
  }
}
