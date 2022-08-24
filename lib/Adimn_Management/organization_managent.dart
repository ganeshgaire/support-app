import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nctserviceapp/Adimn_Management/organizationdetail.dart';
import 'package:nctserviceapp/Adimn_Management/organizationwiseticket.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/component/createorganizationbottomsheet.dart';
import 'package:nctserviceapp/model/organizationmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrganizationList extends StatefulWidget {
  const OrganizationList({Key? key}) : super(key: key);

  @override
  State<OrganizationList> createState() => _OrganizationListState();
}

class _OrganizationListState extends State<OrganizationList> {
  String? totalorganization;
  bool isloading = false;
  List<OrganizationListModel> organizationlist = [];
  TextEditingController organizationcontroller = TextEditingController();
  Future<List<OrganizationListModel>?> getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });

      List<OrganizationListModel> detail = [];

      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse("https://support.nctbutwal.com.np/api/organizations/all"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body)["data"];
      final totalorgan = jsonDecode(response.body)["total_organizations"];

      for (var u in data) {
        detail.add(OrganizationListModel.fromJson(u));
      }

      if (mounted) {
        setState(() {
          totalorganization = totalorgan.toString();
          organizationlist = detail;
          searchlist = detail;
          isloading = false;
        });
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  List<OrganizationListModel> searchlist = [];
  void changeFuction(query) {
    final myList = query.isEmpty
        ? organizationlist
        : organizationlist
            .where((p) => p.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
    setState(() {
      searchlist = myList;
    });
  }

  Future _makePhoneCall(String phoneNumber) async {
    await launchUrl(Uri.parse("tel:$phoneNumber"));
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
        appBar: AppBar(
          backgroundColor: iconColor,
          title: const Text("Organizations"),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet<dynamic>(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return const CreateOrgBottomSheet();
                    });
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  getDatafromApi();
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: organizationcontroller,
                        onChanged: (value) {
                          changeFuction(value);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(
                                    255,
                                    212,
                                    221,
                                    227,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  changeFuction('');
                                  organizationcontroller.clear();
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Search Our Organization'),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemCount: searchlist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OrganizationDetail(
                                  organization: searchlist[index],
                                ),
                              ));
                            },
                            child: Slidable(
                              startActionPane: ActionPane(
                                  extentRatio: 0.3,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: ((context) {
                                        _makePhoneCall(searchlist[index]
                                            .mobileNo
                                            .toString());
                                      }),
                                      icon: Icons.phone,
                                      backgroundColor: Colors.green,
                                    )
                                  ]),
                              endActionPane: ActionPane(
                                  extentRatio: 0.3,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: ((context) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) {
                                          return OrganizationWiseTicket(
                                              orgid: searchlist[index].id!,
                                              orgname: searchlist[index]
                                                  .name
                                                  .toString());
                                        })));
                                      }),
                                      label: "Ticket List",
                                      icon: FontAwesomeIcons.ticket,
                                      backgroundColor: Colors.blue,
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title:
                                      Text(searchlist[index].name.toString()),
                                  subtitle:
                                      Text(searchlist[index].type.toString()),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Total Organization : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  totalorganization.toString(),
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
