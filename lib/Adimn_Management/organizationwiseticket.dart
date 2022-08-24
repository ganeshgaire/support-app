import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/Ticket/ticketdetail.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/myticketmodel.dart';
import 'package:http/http.dart' as http;

class OrganizationWiseTicket extends StatefulWidget {
  int orgid;
  String orgname;
  OrganizationWiseTicket({Key? key, required this.orgid, required this.orgname})
      : super(key: key);

  @override
  State<OrganizationWiseTicket> createState() => _OrganizationWiseTicketState();
}

class _OrganizationWiseTicketState extends State<OrganizationWiseTicket> {
  bool isloading = false;
  Future<List<MyTicketModel>?> getDatafromApi() async {
    try {
      List<MyTicketModel> detail = [];
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      var body = {"organization_id": widget.orgid};
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
          Uri.parse(
              "https://support.nctbutwal.com.np/api/organizations/tickets"),
          headers: headers,
          body: jsonEncode(body));
      final data = jsonDecode(response.body)["data"];
      if (response.statusCode == 200 && mounted) {}
      for (var u in data) {
        detail.add(MyTicketModel.fromJson(u));
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  isrefress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.orgname}'s Ticket"),
        backgroundColor: iconColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          isrefress();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: FutureBuilder<List<MyTicketModel>?>(
            future: getDatafromApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          var myticket = snapshot.data!;
                          return InkWell(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(
                                builder: ((context) {
                                  return TicketDetail(
                                    myticket: myticket[index],
                                  );
                                }),
                              ));
                            }),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  myticket[index]
                                                      .problemType
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "#" +
                                                      myticket[index]
                                                          .ticketId
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                myticket[index].statusText ==
                                                        'Closed'
                                                    ? Text(
                                                        myticket[index]
                                                            .statusText
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    : Text(
                                                        myticket[index]
                                                            .statusText
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    .issuedAt
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Align(
                                                child: Container(
                                                  height: 20,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: getColor(
                                                          myticket[index]
                                                              .priority!),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
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
                        },
                      )
                    : const Center(
                        child: Text(
                        "Ticket Not Found",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
