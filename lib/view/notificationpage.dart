import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/Internal_Task/taskdetail.dart';
import 'package:nctserviceapp/Ticket/ticketdetail.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/tasklistmodel.dart';
import 'package:nctserviceapp/model/notificationmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/myticketmodel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: iconColor,
          actions: const [],
          title: const Text("Notifications"),
        ),
        body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TabBar(
                    labelPadding: EdgeInsets.all(8),
                    indicatorPadding: EdgeInsets.only(left: 20, right: 20),
                    tabs: [
                      Text(
                        "All",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        "Task",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        "Ticket",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    Notificationlist(
                        url:
                            "https://support.nctbutwal.com.np/api/notifications/all"),
                    Notificationlist(
                        url:
                            "https://support.nctbutwal.com.np/api/notifications/tasks"),
                    Notificationlist(
                        url:
                            "https://support.nctbutwal.com.np/api/notifications/tickets"),
                  ]),
                )
              ],
            )));
  }
}

class Notificationlist extends StatefulWidget {
  String url;
  Notificationlist({Key? key, required this.url}) : super(key: key);

  @override
  State<Notificationlist> createState() => _NotificationlistState();
}

class _NotificationlistState extends State<Notificationlist> {
  List<NotificationModel> notificationlist = [];
  bool isloading = false;
  List<MyTicketModel> myticket = [];
  bool isopen = false;

  Future searchTicket(ticketid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<MyTicketModel> detail = [];
      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tickets/search";
      var body = {"ticket_id": ticketid};
      print(ticketid);
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      final data = [jsonDecode(response.body)["data"]];
      print(data);
      for (var u in data) {
        detail.add(MyTicketModel.fromJson(u));
      }
      print(detail);

      if (response.statusCode == 200 && mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: ((context) {
            return TicketDetail(
              myticket: detail[0],
            );
          }),
        ));
      }
    } catch (error) {
      print(error);
    }
  }

  Future searchTask(taskid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<TaskListModel> detail = [];
      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tasks/details";
      var body = {"task_id": taskid};
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      final data = [jsonDecode(response.body)["data"]];
      for (var u in data) {
        detail.add(TaskListModel.fromJson(u));
      }

      if (response.statusCode == 200 && mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: ((context) {
            return TaskDetail(
              tasklist: detail[0],
            );
          }),
        ));
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<NotificationModel>?> getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });

      List<NotificationModel> detail = [];
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse(widget.url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body)["data"];

      for (var u in data) {
        detail.add(NotificationModel.fromJson(u));
      }
      if (mounted) {
        setState(() {
          notificationlist = detail;

          isloading = false;
        });
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatafromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isloading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: notificationlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          notificationlist[index].type == "Ticket"
                              ? searchTicket(notificationlist[index].targetId)
                              : notificationlist[index].type == "Task"
                                  ? searchTask(notificationlist[index].targetId)
                                  : null;
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      notificationlist[index].image.toString()),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notificationlist[index]
                                              .title
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(notificationlist[index]
                                            .message
                                            .toString())
                                      ],
                                    ),
                                  ),
                                ),
                                Text(notificationlist[index]
                                    .notificationAt
                                    .toString())
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
