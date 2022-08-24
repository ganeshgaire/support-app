import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nctserviceapp/Adimn_Management/organizationwiseticket.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nctserviceapp/model/allinformationmodel.dart';
import 'package:nctserviceapp/model/myticketmodel.dart';
import 'package:nctserviceapp/model/remarksmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:nctserviceapp/homepage/generateticket.dart';

class TicketDetail extends StatefulWidget {
  MyTicketModel myticket;
  TicketDetail({Key? key, required this.myticket}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  bool isloading = false;
  bool hidesubmit = false;
  String? _assignedname;
  String? _description;
  String? ticketid;
  bool notifycustomer = true;
  bool showremarks = false;

  List<AllInformationModel> detail = [];

  List<RemarksModel> remarkslist = [];
  List<AllInformationModel> userlist = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController remarkscontroller = TextEditingController();
  TextEditingController closeremarkscontroller = TextEditingController();
  TextEditingController transferremarkscontroller = TextEditingController();

  final snackBar = const SnackBar(
    content: Text('Transfer Ticket Failed'),
    duration: Duration(milliseconds: 800),
  );
  final sucessmsg = const SnackBar(
    content: Text('Transfer Ticket Sucessfully'),
    duration: Duration(milliseconds: 500),
  );
  final closefailed = const SnackBar(
    content: Text('Close Ticket Failed'),
    duration: Duration(milliseconds: 800),
  );
  final closesucess = const SnackBar(
    content: Text(' Ticket Closed Sucessfully'),
    duration: Duration(milliseconds: 800),
  );
  final remarkssucess = const SnackBar(
    content: Text('Sucessfully added remarks'),
    duration: Duration(milliseconds: 800),
  );
  final remarksfailed = const SnackBar(
    content: Text('Cannot added remarks'),
    duration: Duration(milliseconds: 500),
  );

  void getUserData() async {
    try {
      setState(() {
        isloading = true;
      });
      // detail = [];
      var response = await http
          .get(Uri.parse('https://support.nctbutwal.com.np/api/all-info'));
      final data = jsonDecode(response.body)['data'];
      // print(response.body);
      for (var u in data) {
        detail.add(AllInformationModel.fromJson(u));
      }
      if (mounted) {
        setState(() {
          isloading = false;
          userlist = detail;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future transferTicket() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tickets/transfer";
      var body = {
        "ticket_id": ticketid,
        "assigned_to": _assignedname,
        "remarks": transferremarkscontroller.text
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      //print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(sucessmsg);
      }
      if (response.statusCode == 422) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print(error);
    }
  }

  Future closeTicket() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tickets/solve";
      var body = {
        "ticket_id": ticketid,
        "remarks": closeremarkscontroller.text
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(closesucess);
      } else {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(closefailed);
      }
    } catch (error) {
      print(error);
    }
  }

  Future addremarks() async {
    try {
      setState(() {
        hidesubmit = true;
      });

      final prefs = await SharedPreferences.getInstance();
      List<RemarksModel> remarks = [];
      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tickets/remarks/add";
      var body = {
        "ticket_id": ticketid,
        "description": remarkscontroller.text,
        "audience": notifycustomer == true ? 1 : 0
      };

      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      final data = [jsonDecode(response.body)['data']];

      for (var u in data) {
        remarks.add(RemarksModel.fromJson(u));
      }

      if (response.statusCode == 200) {
        setState(() {
          hidesubmit = false;
        });
        remarkscontroller.clear();
        remarkslist.insert(0, remarks[0]);

        ScaffoldMessenger.of(context).showSnackBar(remarkssucess);
      }
      if (response.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(remarksfailed);
      }
    } catch (error) {
      print(error);
    }
  }

  Future getremarks() async {
    try {
      setState(() {
        isloading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      List<RemarksModel> remarks = [];
      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tickets/remarks/all";
      var body = {
        "ticket_id": ticketid,
      };

      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      final data = jsonDecode(response.body)['data'];
      for (var u in data) {
        remarks.add(RemarksModel.fromJson(u));
      }

      if (mounted) {
        setState(() {
          remarkslist = remarks;
          isloading = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future _makePhoneCall(String phoneNumber) async {
    await launchUrl(Uri.parse("tel:$phoneNumber"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getremarks();
    getUserData();

    ticketid = widget.myticket.ticketId;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          getremarks();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: iconColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Ticket_information'),
          ),
          backgroundColor: primaryColor,
          body: isloading
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: (() {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(8.0),
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.myticket.issuedDate
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text("#" +
                                                widget.myticket.ticketId
                                                    .toString()),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              widget.myticket.problemType
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                5.0)),
                                                color: widget.myticket
                                                            .statusText ==
                                                        "Assigned"
                                                    ? Colors.blue
                                                    : widget.myticket
                                                                .statusText ==
                                                            "Opened"
                                                        ? Colors.green
                                                        : Colors.red),
                                            child: Text(
                                              widget.myticket.statusText
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                              child: Text(widget
                                                  .myticket.issuedAt
                                                  .toString()))
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text(
                                      widget.myticket.problemCategory
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Organization :',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _makePhoneCall(widget
                                                        .myticket
                                                        .organizationNumber
                                                        .toString());
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: const [
                                                      Icon(
                                                        Icons.phone,
                                                        size: 16,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(
                                                        " Call Now",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          OrganizationWiseTicket(
                                                        orgid: widget.myticket
                                                            .organizationId!,
                                                        orgname: widget.myticket
                                                            .organizationName!,
                                                      ),
                                                    ));
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      FaIcon(
                                                        FontAwesomeIcons.ticket,
                                                        color: Colors.blue,
                                                        size: 14,
                                                      ),
                                                      Text(
                                                        " Previous Tickets",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        widget.myticket.organizationName
                                            .toString(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Description :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.myticket.details.toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Product Name :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.myticket.productName
                                          .toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Asigned To :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.myticket.assignedTo
                                          .toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Department :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.myticket.departmentName
                                          .toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Issued Date&Time :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.myticket.issuedDate
                                              .toString() +
                                          "  " +
                                          widget.myticket.issuedTime
                                              .toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'State :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Text('Survey'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Priority :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(widget.myticket.priorityText
                                          .toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      widget.myticket.statusText == "Closed"
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Remarks :',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showModalBottomSheet<
                                                                dynamic>(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20))),
                                                            context: context,
                                                            builder: (context) {
                                                              return Column(
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                8.0),
                                                                    child: Text(
                                                                      "Remarks List",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: remarkslist.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return Card(
                                                                            elevation:
                                                                                1,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          remarkslist[index].user!,
                                                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 4,
                                                                                        ),
                                                                                        Text(remarkslist[index].description!),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.topLeft,
                                                                                    child: Text(
                                                                                      remarkslist[index].createdAt.toString(),
                                                                                      style: const TextStyle(fontSize: 10),
                                                                                    ),
                                                                                  ),
                                                                                  const Divider(
                                                                                    height: 2,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      child: const Center(
                                                        child: Text(
                                                          "View Remarks ",
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                        "(${remarkslist.length.toString()})")
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Attachments :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        height: 300,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                widget.myticket.images!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                      content: SizedBox(
                                                        child: Image.network(
                                                            widget.myticket
                                                                    .images![
                                                                index]),
                                                      ),
                                                      actions: <Widget>[
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  ctx);
                                                            },
                                                            child: const Icon(
                                                                Icons.cancel))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 300,
                                                    child: Image.network(
                                                        widget.myticket
                                                            .images![index],
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.myticket.statusText == "Closed"
                          ? const SizedBox()
                          : Column(
                              children: [
                                const Divider(
                                  height: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: notifycustomer,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              notifycustomer = value!;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Text("Make Public"),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showModalBottomSheet<dynamic>(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20))),
                                            context: context,
                                            builder: (context) {
                                              return remarkslist.isNotEmpty
                                                  ? Column(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          child: Text(
                                                            "Remarks List",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      remarkslist
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Card(
                                                                      elevation:
                                                                          1,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    remarkslist[index].user!,
                                                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 4,
                                                                                  ),
                                                                                  Text(remarkslist[index].description!),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Text(
                                                                                remarkslist[index].createdAt.toString(),
                                                                                style: const TextStyle(fontSize: 10),
                                                                              ),
                                                                            ),
                                                                            const Divider(
                                                                              height: 2,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                      ],
                                                    )
                                                  : const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                              "No data found")),
                                                    );
                                            });
                                      },
                                      child: Text(
                                          "View Remarks (${remarkslist.length.toString()})"),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            validator: ((value) {
                                              if (value!.isEmpty) {
                                                return 'field can\'t be empty ';
                                              }

                                              return null;
                                            }),
                                            controller: remarkscontroller,
                                            style:
                                                const TextStyle(fontSize: 17),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 2,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              focusedBorder:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10,
                                                      top: 10,
                                                      bottom: 10),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'Remarks',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();

                                              addremarks();
                                            }
                                          },
                                          child: !hidesubmit
                                              ? const FaIcon(
                                                  FontAwesomeIcons
                                                      .solidPaperPlane,
                                                  color: Colors.blue)
                                              : const SizedBox(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                      widget.myticket.statusText == "Closed"
                          ? const SizedBox()
                          : widget.myticket.statusText == "Assigned"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // maximumSize: const Size(double.infinity, 35),
                                          // minimumSize: const Size(double.infinity, 35),
                                          elevation: 2,
                                          primary: Colors.green,
                                          onPrimary: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    actions: [
                                                      const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Remarks',
                                                          style: TextStyle(
                                                              color: iconColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      TextFormField(
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: 5,
                                                        controller:
                                                            closeremarkscontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          focusedBorder:
                                                              const OutlineInputBorder(),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 10,
                                                                  bottom: 10),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: 'Remarks',
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          iconColor),
                                                              onPressed: () {
                                                                setState(() {
                                                                  isloading =
                                                                      true;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                                closeTicket();
                                                              },
                                                              child: const Text(
                                                                  'Submit')),
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: const Text(
                                          "Close Ticket",

                                          // textScaleFactor: 1.2,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // maximumSize: const Size(double.infinity, 35),
                                          // minimumSize: const Size(double.infinity, 35),
                                          elevation: 2,
                                          primary: iconColor,
                                          onPrimary: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    actions: [
                                                      const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Asigned To',
                                                          style: TextStyle(
                                                              color: iconColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child:
                                                            DropdownButtonFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .always,
                                                          //isExpanded: false,
                                                          hint: const Text(
                                                              'Select Users'),
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            border: InputBorder
                                                                .none,
                                                          ),

                                                          value: _assignedname,
                                                          isDense: true,
                                                          onChanged: (value) {
                                                            // print(userslist);
                                                            setState(() {
                                                              _assignedname =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },

                                                          items: userlist[0]
                                                              .users
                                                              ?.map((Users?
                                                                  value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value!.id
                                                                  .toString(),
                                                              child: Text(value
                                                                  .name
                                                                  .toString()),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Remarks',
                                                          style: TextStyle(
                                                              color: iconColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      TextFormField(
                                                        validator: ((value) {
                                                          if (value!.isEmpty) {
                                                            return 'field can\'t be empty ';
                                                          }

                                                          return null;
                                                        }),
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                        cursorHeight: 25,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: 5,
                                                        controller:
                                                            transferremarkscontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          focusedBorder:
                                                              const OutlineInputBorder(),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 10,
                                                                  bottom: 10),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: 'Remarks',
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          iconColor),
                                                              onPressed: () {
                                                                setState(() {
                                                                  isloading =
                                                                      true;
                                                                });
                                                                _formKey
                                                                    .currentState!
                                                                    .save();

                                                                ticketid = widget
                                                                    .myticket
                                                                    .ticketId;
                                                                transferTicket();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Submit')),
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: const Text(
                                          "Transfer Ticket",

                                          // textScaleFactor: 1.2,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 60,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          // maximumSize: const Size(double.infinity, 35),
                                          // minimumSize: const Size(double.infinity, 35),
                                          elevation: 2,
                                          primary: Colors.green,
                                          onPrimary: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    actions: [
                                                      const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Remarks',
                                                          style: TextStyle(
                                                              color: iconColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            closeremarkscontroller,
                                                        validator: ((value) {
                                                          if (value!.isEmpty) {
                                                            return 'field can\'t be empty ';
                                                          }

                                                          return null;
                                                        }),
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                        cursorHeight: 25,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: 5,
                                                        decoration:
                                                            InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          focusedBorder:
                                                              const OutlineInputBorder(),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 10,
                                                                  bottom: 10),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: 'Remarks',
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          iconColor),
                                                              onPressed: () {
                                                                setState(() {
                                                                  isloading =
                                                                      true;
                                                                });
                                                                _formKey
                                                                    .currentState!
                                                                    .save();

                                                                ticketid = widget
                                                                    .myticket
                                                                    .ticketId;
                                                                closeTicket();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Submit')),
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: const Text(
                                          "Close Ticket",

                                          // textScaleFactor: 1.2,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
