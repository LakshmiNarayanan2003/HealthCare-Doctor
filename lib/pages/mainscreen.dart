import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doctor/pages/credit.dart';
import 'package:doctor/src/pages/home_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          HomePage(),
          CreditPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(
            Icons.home,
            color: Theme.of(context).accentColor,
          ),
          Icon(
            Icons.library_add_check_sharp,
            color: Colors.green,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
            navigationTapped(_page);
          });
        },
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
