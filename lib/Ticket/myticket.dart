import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/filtermodel.dart';

import 'ticketlist.dart';

class MyTicket extends StatefulWidget {
  const MyTicket({
    Key? key,
  }) : super(key: key);

  @override
  State<MyTicket> createState() => _MyTicketState();
}

class _MyTicketState extends State<MyTicket> {
  bool isdatechange = false;
  bool isloading = false;

  String? selectedDate = "Select Date..";
  String? datechoosed = "";

  var myFormat = DateFormat('yyyy-MM-d');

  final filterlist = [
    FilterModel(
        "All Tickets", "https://support.nctbutwal.com.np/api/tickets/all"),
    FilterModel("Transfered Tickets",
        "https://support.nctbutwal.com.np/api/tickets/transfered"),
    FilterModel("Pending Tickets",
        "https://support.nctbutwal.com.np/api/tickets/opened"),
    FilterModel("Solved Tickets",
        "https://support.nctbutwal.com.np/api/tickets/closed"),
    FilterModel("Assigned Tickets",
        "https://support.nctbutwal.com.np/api/tickets/assigned"),
    FilterModel("Created Tickets",
        "https://support.nctbutwal.com.np/api/tickets/created"),
  ];
  late FilterModel dropdownvalue = filterlist[0];
  dateTimePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = (myFormat.format(picked).toString());
        datechoosed = (myFormat.format(picked).toString());
        isdatechange = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isdatechange = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text('My Tickets'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<FilterModel>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 8),
                      border: InputBorder.none,
                    ),
                    value: dropdownvalue,
                    onSaved: (value) {},
                    isDense: true,
                    onChanged: (value) {
                      setState(() {
                        dropdownvalue = value!;
                        isdatechange = false;
                        selectedDate = "Select Date..";
                        datechoosed = "";
                      });
                    },
                    items: filterlist.map((data) {
                      return DropdownMenuItem<FilterModel>(
                        value: data,
                        child: Text(data.name.toString()),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: 1,
                  color: const Color.fromARGB(255, 202, 196, 196),
                ),
                Expanded(
                  child: TextFormField(
                    showCursor: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    onTap: dateTimePicker,

                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        top: 14,
                        left: 10,
                      ),
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: selectedDate,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AllTicket(
                  date: datechoosed.toString(),
                  url: dropdownvalue.url!,
                )),
          ),
        ],
      ),
    );
  }
}
