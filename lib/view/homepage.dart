import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/view/notificationpage.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import 'package:nctserviceapp/view/searchpage.dart';
import 'package:nctserviceapp/Survey/surveypage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../Adimn_Management/adminmanagement.dart';
import '../Ticket/generateticket.dart';
import '../Ticket/myticket.dart';
import '../Internal_Task/internaltask.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> contactlist = [];
  String? usertype;
  Future getPhoneNumber() async {
    try {
      setState(() {
        isloading = true;
      });

      var response = await http.get(
        Uri.parse('https://support.nctbutwal.com.np/api/departments/all'),
      );

      final data = jsonDecode(response.body)["data"];
      contactlist = data;

      if (mounted) {
        setState(() {
          isloading = false;
        });
      }

      return 'sucess';
    } catch (e) {
      print(e);
    }
  }

  void userdataread() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      usertype = prefs.getString('user_type');
    });
    print(usertype);
  }

  Future _makePhoneCall(String phoneNumber) async {
    await launchUrl(Uri.parse("tel:$phoneNumber"));
  }

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
    userdataread();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: iconColor,
          title: const Text('NCT Support Service'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const NotificationPage()));
                },
                icon: const Icon(
                  Icons.notifications,
                  size: 35,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/sticker.png')),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Need Technical Support?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                            'You are just a click away from a solution!'),
                        const Text('We are at your service 24 hours!')
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    InkWell(
                      onTap: (() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) {
                            return GenerateTicket();
                          }),
                        ));
                      }),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/maketicket.png',
                              height: 110,
                            ),
                            const Text(
                              'Generate Tickets',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) {
                            return const MyTicket();
                          }),
                        ));
                      }),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/ticket.png',
                              height: 110,
                            ),
                            const Text(
                              'My Tickets',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) {
                            return const SurveyPage();
                          }),
                        ));
                      }),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.checklist_outlined,
                              size: 110,
                              color: iconColor,
                            ),
                            Text(
                              'Survey',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) {
                            return const InternalTask();
                          }),
                        ));
                      }),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.task_alt,
                              size: 110,
                              color: Colors.blueAccent,
                            ),
                            Text(
                              'Internal Task',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    usertype == "Staff"
                        ? InkWell(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(
                                builder: ((context) {
                                  return const TicketSearchPage();
                                }),
                              ));
                            }),
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/searchticket.png',
                                    height: 110,
                                  ),
                                  const Text(
                                    'Search Tickets',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(
                                builder: ((context) {
                                  return const AdminManagementPage();
                                }),
                              ));
                            }),
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/adminlogo.png',
                                    height: 110,
                                  ),
                                  const Text(
                                    'Management',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                    InkWell(
                      onTap: (() {
                        showModalBottomSheet<dynamic>(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            context: context,
                            builder: (context) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: contactlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        _makePhoneCall(
                                            contactlist[index]["contact"]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  child: contactlist[index][
                                                              "contact_network"] ==
                                                          "NTC"
                                                      ? Image.asset(
                                                          'assets/ntclogo.png',
                                                          height: 40,
                                                        )
                                                      : Image.asset(
                                                          'assets/ncell.png',
                                                          height: 40,
                                                        ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(contactlist[index]
                                                    ["contact"]),
                                              ],
                                            ),
                                            Text(contactlist[index]
                                                ["departmentname"])
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            });
                      }),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/call.png',
                              height: 110,
                            ),
                            const Text(
                              'Make a Call',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
