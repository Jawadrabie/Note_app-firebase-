import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/screen/AddCatogary.dart';
import 'package:waelfirebase/screen/home.dart';
import 'package:waelfirebase/screen/image_Picker/image_Picker.dart';
import 'package:waelfirebase/screen/login.dart';
import 'package:waelfirebase/screen/register.dart';
import 'package:waelfirebase/show.dart';
import 'package:waelfirebase/testting/Filter.dart';
import 'package:waelfirebase/testting/test.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
// Import the generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('=========================User is currently signed out!');
      } else {
        print('==========================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.brown)),
      home:
          // notification(),
          FirebaseAuth.instance.currentUser == null ? loginPage() : HomePage(),
      routes: {
        "RegisterPage": (context) => RegisterPage(),
        "HomePage": (context) => HomePage(),
        "LoginPage": (context) => loginPage(),
        "addCatogary": (context) => addCatogary(),
      },
    );
  }
}
