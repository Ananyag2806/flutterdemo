import 'package:flutter/material.dart';

import 'board.dart';
import 'insights.dart';
import 'profile.dart';

void main() => runApp(const HomePage());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;

  final _pageOptions = [
    const ScrumBoard(),
    const Insights(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            body: _pageOptions[selectedPage],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard, size: 30), label: 'Board'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.insights, size: 30), label: 'Insights'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle, size: 30),
                    label: 'Profile'),
              ],
              selectedItemColor: Colors.green,
              elevation: 5.0,
              unselectedItemColor: Colors.green[900],
              currentIndex: selectedPage,
              backgroundColor: Colors.white,
              onTap: (index) {
                setState(() {
                  selectedPage = index;
                });
              },
            )));
  }
}
