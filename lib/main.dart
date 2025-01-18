import 'package:app_toplanti/firebase_options.dart';
import 'package:app_toplanti/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/girisSayfasi":(context) => LoginPage(),
          "/kayitSayfasi":(context) => RegisterPage(),
        },
        home:LoginPage()
    );
  }

}