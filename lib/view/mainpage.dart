import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nctserviceapp/view/notificationpage.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/localnotificationservice.dart';
import 'package:nctserviceapp/view/homepage.dart';
import 'package:nctserviceapp/Ticket/myticket.dart';
import 'package:nctserviceapp/Profile_Page/profilepage.dart';
import 'package:nctserviceapp/view/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Profile_Page/profilepage.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  late String name;
  late String userimage;
  late String token;
  late String apitoken;

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const Homepage(),
    const TicketSearchPage(),
    // const SizedBox.shrink(),
    const MyTicket(),
    const ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    userdataread();
    super.initState();
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {},
        );

    // 2. This method only call when App in forground it mean app must be opened
    if (mounted) {
      FirebaseMessaging.onMessage.listen(
        (message) {
          if (message.notification != null) {
            LocalNotificationService.createanddisplaynotification(
                context, message);
          }
        },
      );
      // 3. This method only call when App in background and not terminated(not closed)
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
          if (message.notification != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const NotificationPage()));
          }
        },
      );
    }
  }

  userdataread() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('userData');
    final String? token = prefs.getString('token');
    final data = jsonDecode(userData!);

    setState(() {
      name = data['name'];
      userimage = data['profile_image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
          child: SizedBox(
            height: 60,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(8),
              child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  currentIndex: _selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onItemTapped,
                  unselectedFontSize: 0,
                  selectedFontSize: 0,
                  items: [
                    _selectedIndex == 0
                        ? const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.home,
                              size: 34,
                              color: iconColor,
                            ),
                            label: '')
                        : const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.home,
                              size: 30,
                              color: unSelectedColor,
                            ),
                            label: ''),
                    _selectedIndex == 1
                        ? const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.search_outlined,
                              size: 34,
                              color: iconColor,
                            ),
                            label: '')
                        : const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.search_outlined,
                              color: unSelectedColor,
                              size: 30,
                            ),
                            label: ''),
                    _selectedIndex == 2
                        ? const BottomNavigationBarItem(
                            icon: FaIcon(
                              FontAwesomeIcons.ticket,
                              color: iconColor,
                              size: 34,
                            ),
                            label: '')
                        : const BottomNavigationBarItem(
                            icon: FaIcon(
                              FontAwesomeIcons.ticket,
                              color: unSelectedColor,
                            ),
                            label: ''),
                    _selectedIndex == 3
                        ? const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.person,
                              size: 34,
                              color: iconColor,
                            ),
                            label: '')
                        : const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.person,
                              color: unSelectedColor,
                              size: 30,
                            ),
                            label: ''),
                  ]),
            ),
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
