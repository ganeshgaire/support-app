import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/tasklistmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TaskDetail extends StatefulWidget {
  TaskListModel tasklist;

  TaskDetail({Key? key, required this.tasklist}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  bool isloading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController remarkscontroller = TextEditingController();
  final startsucess = const SnackBar(
    content: Text('Task Started Sucessfully'),
    duration: Duration(milliseconds: 800),
  );
  final startfailed = const SnackBar(
    content: Text('Task Started Failed'),
    duration: Duration(milliseconds: 800),
  );
  final completefailed = const SnackBar(
    content: Text('Completed task failed'),
    duration: Duration(milliseconds: 800),
  );
  final completesucess = const SnackBar(
    content: Text(' Completed Task Sucessfully'),
    duration: Duration(milliseconds: 800),
  );
  Future completedTask() async {
    try {
      // print(remarkscontroller.text);
      // print(widget.tasklist.id);
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tasks/complete";
      var body = {"id": widget.tasklist.id, "remarks": remarkscontroller.text};
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      //print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);

        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(completesucess);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(completefailed);
        setState(() {
          isloading = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future startTask() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tasks/inprogress";
      var body = {"id": widget.tasklist.id, "remarks": remarkscontroller.text};
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);

        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(startsucess);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(startfailed);
        setState(() {
          isloading = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
          backgroundColor: iconColor,
          title: const Text("Task Detail")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              children: [
                const Text(
                  'Title :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.tasklist.title.toString(),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Created by:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.tasklist.createdBy.toString()),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Created To:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.tasklist.user.toString()),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Created date :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.tasklist.createdDateTime.toString()),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Description :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.tasklist.description.toString()),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Priority:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.tasklist.priorityText.toString()),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    "${widget.tasklist.statusText.toString()}    (${widget.tasklist.updatedAt})"),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Remarks:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(widget.tasklist.remarks.toString()),
                const Text(
                  'Attachments :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2)),
                  height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.tasklist.image!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: SizedBox(
                                  child: Image.network(
                                      widget.tasklist.image![index]),
                                ),
                                actions: <Widget>[
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: const Icon(Icons.cancel))
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 300,
                              child:
                                  Image.network(widget.tasklist.image![index],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
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
          SizedBox(
            height: 60,
            child: widget.tasklist.status == 1
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        primary: Colors.green,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  actions: [
                                    Center(
                                      child: Form(
                                        key: _formKey,
                                        child: const Text(
                                          'Starting Task Remarks',
                                          style: TextStyle(
                                              color: iconColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
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
                                      style: const TextStyle(fontSize: 17),
                                      cursorHeight: 25,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      controller: remarkscontroller,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        focusedBorder:
                                            const OutlineInputBorder(),
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, top: 10, bottom: 10),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Remarks',
                                      ),
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: iconColor),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isloading = true;
                                              });
                                              startTask();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text(
                                            'Start Task',
                                          )),
                                    )
                                  ],
                                ));
                      },
                      child: isloading
                          ? const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                "Start Task",

                                // textScaleFactor: 1.2,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                    ),
                  )
                : widget.tasklist.status == 2
                    ? Center(
                        child: Form(
                          key: _formKey,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              primary: Colors.red,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        actions: [
                                          const Center(
                                            child: Text(
                                              'Completed Task Remarks',
                                              style: TextStyle(
                                                  color: iconColor,
                                                  fontWeight: FontWeight.w500,
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
                                            style:
                                                const TextStyle(fontSize: 17),
                                            cursorHeight: 25,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 5,
                                            controller: remarkscontroller,
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
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Center(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: iconColor),
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _formKey.currentState!
                                                        .save();
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    completedTask();
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text(
                                                    'Complete Task')),
                                          )
                                        ],
                                      ));
                            },
                            child: isloading
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Text(
                                      "Complete Task",

                                      // textScaleFactor: 1.2,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                          ),
                        ),
                      )
                    : const SizedBox(),
          )
        ],
      ),
    );
  }
}
