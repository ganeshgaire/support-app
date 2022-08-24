import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/myticketmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Ticket/ticketdetail.dart';

class TicketSearchPage extends StatefulWidget {
  const TicketSearchPage({Key? key}) : super(key: key);

  @override
  State<TicketSearchPage> createState() => _SearchpageState();
}

class _SearchpageState extends State<TicketSearchPage> {
  String? ticketid;
  bool ishide = false;
  List<MyTicketModel> myticket = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final snackBar = const SnackBar(
    content: Text('Ticket Not Found'),
    duration: Duration(milliseconds: 500),
  );

  Future searchTicket() async {
    try {
      setState(() {
        ishide = true;
      });
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

      if (response.statusCode == 200 && mounted) {
        for (var u in data) {
          detail.add(MyTicketModel.fromJson(u));
        }
        setState(() {
          ishide = false;
        });
        Navigator.push(context, MaterialPageRoute(
          builder: ((context) {
            return TicketDetail(
              myticket: detail[0],
            );
          }),
        ));
      } else if (response.statusCode == 404) {
        setState(() {
          ishide = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              " Ticket Not Found",
            )));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: iconColor, title: const Text("Search Ticket")),
        backgroundColor: primaryColor,
        body: Column(children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            height: 80,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/logo.png'))),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    autofocus: true,
                    onSaved: ((input) {
                      setState(() {
                        ticketid = input;
                      });
                    }),
                    decoration:
                        const InputDecoration(prefix: Text('Ticket Id-#')),
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return 'field can\'t be empty ';
                      }

                      return null;
                    }),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                !ishide
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: iconColor),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            searchTicket();
                          }
                        },
                        child: const Text('Search Tickets'),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
