import 'package:flutter/material.dart';
import 'package:rchapp_v2/sreens/authen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Opun',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2f5233)),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      title: 'RCH App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(title: 'Rch plus'), // Set the initial screen
    );
  }
}

