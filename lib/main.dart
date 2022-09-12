import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_app/view/screens/canvas.dart';
import 'package:word_app/view/screens/list_page.dart';
import 'package:word_app/view/screens/login_page.dart';
import 'package:word_app/view/screens/main_page.dart';
import 'package:word_app/view/screens/provider_page.dart';
import 'package:word_app/view/screens/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          : MainProviderPage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        ListPage.routeName: (context) => const ListPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        ProviderPage.routeName: (context) => const ProviderPage(),
        MainProviderPage.routeName: (context) => const MainProviderPage(),
      },
    );
  }
}
