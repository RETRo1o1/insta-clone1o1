import 'package:flutter/material.dart';
import 'package:insta_clone/screens/bodies/add_images.dart';
import 'package:insta_clone/screens/bodies/imagebody.dart';
import 'package:insta_clone/screens/bodies/profile.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/firstscreen.dart';
import 'package:insta_clone/screens/bodies/testfeed.dart';


class BottomNavigation extends StatefulWidget {
  // const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if(_selectedIndex == 0){
      Navigator.push(context,
      MaterialPageRoute(
        builder: (context) =>
            TestFeed(),
      ));
    }
    if(_selectedIndex == 1) {
      Navigator.push(context,
      MaterialPageRoute(
        builder: (context) =>
           CreatePost(),
      ));
    }
    if(_selectedIndex == 2) {
      Navigator.push(context,
      MaterialPageRoute(
        builder: (context) =>
            ProfilePage(),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(Icons.home_filled,)
                : Icon(Icons.home),
                      title: Text(
                        "",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),

          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(Icons.add_box_outlined)
                : Icon(Icons.add_box),
                      title: Text(
                        "",
                        style: TextStyle(
                          color: Colors.black,
                        )
                      )
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(Icons.account_circle_outlined)
                : Icon(Icons.account_circle_rounded),
                      title: Text(
                        "",
                        style: TextStyle(
                          color: Colors.black,
                        )

                      )
          )

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 0,
      )




    );
  }
}
