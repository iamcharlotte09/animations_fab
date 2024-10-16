import 'package:animations_2/screen/screen_two.dart';
import 'package:animations_2/screen/home.screen.dart';
import 'package:animations_2/screen/screen_three.dart';
import 'package:animations_2/screen/screen_four.dart';
import 'package:animations_2/screen/screen_one.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
