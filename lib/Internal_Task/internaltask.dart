import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nctserviceapp/Internal_Task/tasklist.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import 'package:nctserviceapp/model/filtermodel.dart';

import 'create_task.dart';

class InternalTask extends StatefulWidget {
  const InternalTask({
    Key? key,
  }) : super(key: key);

  @override
  State<InternalTask> createState() => _InternalTaskState();
}

class _InternalTaskState extends State<InternalTask> {
  // bool isdatechange = false;
  bool isdropdownchanged = false;
  bool isloading = false;

  String? startingdate = "Select Date..";
  String? startingdatechoose = "";
  String? endingdate = "Select Date..";
  String? endingdatechoosed = "";

  var myFormat = DateFormat('yyyy-MM-d');

  final taskfilter = [
    TaskFilterMOdel(
        "New Tasks", "https://support.nctbutwal.com.np/api/tasks/filter/new"),
    TaskFilterMOdel(
        "All Tasks", "https://support.nctbutwal.com.np/api/tasks/filter/all"),
    TaskFilterMOdel("In Progress Tasks",
        "https://support.nctbutwal.com.np/api/tasks/filter/inprogress"),
    TaskFilterMOdel("Completed Tasks",
        "https://support.nctbutwal.com.np/api/tasks/filter/completed"),
  ];
  late TaskFilterMOdel dropdownvalue = taskfilter[0];
  void dateTimePicker(BuildContext context, bool isStartingDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartingDate) {
          startingdate = (myFormat.format(picked).toString());
          startingdatechoose = (myFormat.format(picked).toString());
        } else {
          endingdate = (myFormat.format(picked).toString());
          endingdatechoosed = (myFormat.format(picked).toString());
          // isdatechange = true;
        }
      });
    }
  }

  bool iscreated = false;
  isrefress(value) {
    if (value == true) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isdatechange = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Center(child: Text("Internal Task")),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreateTask();
              })).then((value) {
                isrefress(value);
              });
            },
            child: Row(
              children: const [
                Icon(
                  Icons.add,
                  size: 20,
                ),
                Text(
                  " Create Task",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ],
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
                  child: DropdownButtonFormField<TaskFilterMOdel>(
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
                        // isdatechange = false;
                        startingdate = "Select Date..";
                        startingdatechoose = "";
                        endingdate = "Select Date..";
                        endingdatechoosed = "";
                        isdropdownchanged = true;
                      });
                    },
                    items: taskfilter.map((data) {
                      return DropdownMenuItem<TaskFilterMOdel>(
                        value: data,
                        child: Text(
                          data.name.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: TextFormField(
                    showCursor: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    onTap: () {
                      dateTimePicker(context, true);
                    },

                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        top: 14,
                        left: 10,
                      ),
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: startingdate,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: TextFormField(
                    showCursor: false,
                    // enabled: false,
                    keyboardType: TextInputType.none,
                    onTap: () {
                      dateTimePicker(context, false);
                    },

                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        top: 14,
                        left: 10,
                      ),
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: endingdate,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: TaskList(
            url: dropdownvalue.url!,
            startingdate: startingdatechoose.toString(),
            endingdate: endingdatechoosed.toString(),
          )),
        ],
      ),
    );
  }
}
