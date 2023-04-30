import 'package:flutter/material.dart';

import 'board.dart';

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0)),
        home: const Scaffold(body: ScrumBoard()));
  }
}
