import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/chat/authentication_screen.dart';
import 'package:flutter_app/chat/chat_screen.dart';
import 'package:flutter_app/chat/image_capture_widget.dart';

void main() => runApp(new MyApp());

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.blue, accentColor: Colors.orangeAccent[400]);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to Flutter",
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: ChatScreen());
  }
}
