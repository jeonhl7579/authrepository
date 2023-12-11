import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth_provider/pages/home_page.dart';
import 'package:fb_auth_provider/pages/signup_page.dart';
import 'package:fb_auth_provider/pages/singin_page.dart';
import 'package:fb_auth_provider/pages/splash_page.dart';
import 'package:fb_auth_provider/providers/auth/auth_provider.dart';
import 'package:fb_auth_provider/providers/signin/singin_provider.dart';
import 'package:fb_auth_provider/providers/signup/signup_provider.dart';
import 'package:fb_auth_provider/repositories/authrepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: fbAuth.FirebaseAuth.instance),
        ),
        StreamProvider<fbAuth.User?>(
          create: (context)=>context.read<AuthRepository>().user,
          initialData: null,
        ),
        ChangeNotifierProxyProvider<fbAuth.User?,AuthProvider>(
            create: (context)=>AuthProvider(authRepository: context.read<AuthRepository>()),
            update: (BuildContext context,fbAuth.User? userStream, AuthProvider? authProvider){
              return authProvider!..update(userStream);
            }
        ),
        ChangeNotifierProvider<SigninProvider>(create: (context)=>SigninProvider(authRepository: context.read<AuthRepository>())),
        ChangeNotifierProvider<SignupProvider>(create: (context)=>SignupProvider(authRepository: context.read<AuthRepository>())),
      ],
      child: MaterialApp(
        title: 'AuthProvider',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashPage(),
        routes: {
          SignupPage.routeName: (context) => SignupPage(),
          SigninPage.routeName: (context) => SigninPage(),
          HomePage.routeName: (context) => HomePage(),
        },
      ),
    );
  }
}
