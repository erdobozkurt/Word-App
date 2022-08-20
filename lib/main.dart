import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_app/view/screens/list_page.dart';
import 'package:word_app/view/screens/login_page.dart';
import 'package:word_app/view/screens/main_page.dart';
import 'package:word_app/view/screens/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade300,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? LoginPage.routeName
          : MainPage.routeName,
      routes: {
        MyApp.routeName: (context) => const MyApp(),
        MainPage.routeName: (context) => const MainPage(),
        ListPage.routeName: (context) => const ListPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
      },
    );
  }
}
