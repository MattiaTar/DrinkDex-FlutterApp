import 'package:bartolinimauri/pages/home_page.dart';
import 'package:bartolinimauri/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'Screen/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B&M',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>SplashScreen(), //la splash screen come schermata iniziale
        'Loginpage': (context) => LoginPage(), // Login attualmente sospesa
        'HomePage': (context) => HomePage(),
      },
    );
  }
}
