import 'package:app_tp/GifsPage.dart';
import 'package:app_tp/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gifs',
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
        '/gifs': (context) => GifsPage(),
      },
    );
  }
}