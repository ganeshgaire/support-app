import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/Internal_Task/taskdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'taskdetail.dart';
import '../component/constantcolor.dart';
import '../model/tasklistmodel.dart';

class TaskList extends StatefulWidget {
  String url;
  String startingdate;
  String endingdate;
  TaskList(
      {Key? key,
      required this.url,
      required this.startingdate,
      required this.endingdate})
      : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool isloading = false;

  Future<List<TaskListModel>?> getDatafromApi() async {
    try {
      List<TaskListModel> detail = [];
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      var body = {
        "start_date": widget.startingdate,
        "end_date": widget.endingdate
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(widget.url),
          headers: headers, body: jsonEncode(body));
      final data = jsonDecode(response.body)["data"];

      if (response.statusCode == 200 && mounted) {}
      for (var u in data) {
        detail.add(TaskListModel.fromJson(u));
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  isrefress(value) {
    if (value == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        isrefress(true);
      },
      child: FutureBuilder<List<TaskListModel>?>(
          future: getDatafromApi(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        var myticket = snapshot.data!;
                        return InkWell(
                          onTap: (() {
                            Navigator.push(context, MaterialPageRoute(
                              builder: ((context) {
                                return TaskDetail(
                                  tasklist: myticket[index],
                                );
                              }),
                            )).then((value) {
                              if (value) {
                                isrefress(value);
                              }
                            });
                          }),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        myticket[index].issuedDay.toString(),
                                        style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        myticket[index]
                                            .issuedMonthYear
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                myticket[index]
                                                    .title
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    myticket[index]
                                                        .createdBy
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    myticket[index]
                                                        .user
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              myticket[index].statusText ==
                                                      'Completed'
                                                  ? Text(
                                                      myticket[index]
                                                          .statusText
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  : Text(
                                                      myticket[index]
                                                          .statusText
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              myticket[index]
                                                  .createdAt
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  color: getColor(
                                                      myticket[index]
                                                          .priority!),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Center(
                                                child: Text(
                                                  myticket[index]
                                                      .priorityText
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : const Center(
                      child: Text(
                      "Task Not Found",
                      style: TextStyle(fontSize: 24),
                    ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
