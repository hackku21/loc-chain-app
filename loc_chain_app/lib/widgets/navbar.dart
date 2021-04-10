import 'package:flutter/material.dart';
import 'package:loc_chain_app/pages/home.dart';
import 'package:loc_chain_app/pages/keygen.dart';

class NavBarWidget extends StatefulWidget {
  NavBarWidget({Key key}) : super(key: key);

  @override
  _NavBarWidgetState createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int _selectedIndex = 0;
  StatefulWidget _selectedWidget;
  static List<Widget> pages = <Widget>[
    HomePage(
      title: 'Home',
    ),
    KeygenPage(
      title: 'RSA Configuration',
    ),
  ];
  void _onItemTapped(int index) => setState(() {
        _selectedIndex = index;
        _selectedWidget = pages[_selectedIndex];
      });

  @override
  Widget build(context) => Scaffold(
        body: _selectedWidget,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
              backgroundColor: Colors.cyan,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_rounded),
              label: 'RSA Configuration',
              backgroundColor: Colors.cyan,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.lightBlue[200],
          onTap: _onItemTapped,
        ),
      );
}
