import 'package:flutter/material.dart';
import 'package:flutter_app/screen_random_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        theme: ThemeData(primaryColor: Colors.white),
        home: RandomWordsScreen());
  }
}
