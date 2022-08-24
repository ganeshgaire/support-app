import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/licensemodel.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LicenseManagementPage extends StatefulWidget {
  const LicenseManagementPage({Key? key}) : super(key: key);

  @override
  State<LicenseManagementPage> createState() => _LicenseManagementPageState();
}

class _LicenseManagementPageState extends State<LicenseManagementPage> {
  bool isloading = false;
  List<LicenseListModel> licenselist = [];
  List<LicenseListModel> liscensedetail = [];
  TextEditingController licensecontroller = TextEditingController();

  Future getLicenseDetail() async {
    try {
      setState(() {
        isloading = true;
      });
      List<LicenseListModel> detail = [];

      String url =
          "https://server-restroms.nctbutwal.com.np/api/support-app/v1/restaurant/license/all";

      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'api_key':
            'SUPPORTAPPVs6KSWeJztptlu9rEYeRweVGxDwn5r1GuaHrofpRBnS4plSpqCP1YJ',
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      print(response.statusCode);
      final data = jsonDecode(response.body)["data"];
      print(response.body);
      if (response.statusCode == 200 && mounted) {
        setState(() {
          isloading = false;
        });
        for (var u in data) {
          detail.add(LicenseListModel.fromJson(u));
        }
        setState(() {
          liscensedetail = detail;
          licenselist = detail;
          searchlist = detail;

          isloading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              " License Not Assigned",
            )));
      }
    } catch (error) {
      print(error);
    }
  }

  List<LicenseListModel> searchlist = [];
  void changeFuction(query) {
    final myList = query.isEmpty
        ? licenselist
        : licenselist
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

    getLicenseDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: iconColor,
          title: const Text("Licenses"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  getLicenseDetail();
                },
                child: isloading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: licensecontroller,
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
                                        licensecontroller.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  hintText: 'Search License'),
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
                                    showModalBottomSheet<dynamic>(
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                        "License Detail",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  const Text(
                                                    'License Name',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(searchlist[index]
                                                          .name
                                                          .toString()),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            searchlist[index]
                                                                .remainingTime
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: searchlist[index]
                                                                            .expiryStatus ==
                                                                        1
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          searchlist[index]
                                                                      .expiryStatus ==
                                                                  1
                                                              ? const Text(
                                                                  " Remaining",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              : const SizedBox()
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Representative Name',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .usedBy!
                                                      .representativeName
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Mobile No.',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .usedBy!
                                                      .mobileNo
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Expiry Date',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .expiryDate
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Created At',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .createdAt
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Slidable(
                                    startActionPane: ActionPane(
                                        extentRatio: 0.3,
                                        motion: const StretchMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: ((context) {
                                              _makePhoneCall(searchlist[index]
                                                  .usedBy!
                                                  .mobileNo
                                                  .toString());
                                            }),
                                            icon: Icons.phone,
                                            backgroundColor: Colors.green,
                                          )
                                        ]),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              searchlist[index].name.toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  searchlist[index]
                                                      .remainingTime
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: searchlist[index]
                                                                  .expiryStatus ==
                                                              0
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                searchlist[index]
                                                            .expiryStatus ==
                                                        1
                                                    ? const Text(
                                                        " Remaining",
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ));
  }
}

class DepartmentModel {
  int? id;
  String? departmentname;
  String? contact;
  String? contactNetwork;

  DepartmentModel(
      {this.id, this.departmentname, this.contact, this.contactNetwork});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentname = json['departmentname'];
    contact = json['contact'];
    contactNetwork = json['contact_network'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['departmentname'] = departmentname;
    data['contact'] = contact;
    data['contact_network'] = contactNetwork;
    return data;
  }
}
