import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nctserviceapp/Adimn_Management/organizationwiseticket.dart';
import 'package:nctserviceapp/Adimn_Management/userdetail.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool isloading = false;
  bool ishide = false;
  List<UserModel> userlist = [];
  List<DepartmentModel> departmentlist = [];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilenumcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var deptype;
  Future<List<UserModel>?> getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });

      List<UserModel> detail = [];

      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse("https://support.nctbutwal.com.np/api/users/all"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body)["data"];

      for (var u in data) {
        detail.add(UserModel.fromJson(u));
      }

      List<DepartmentModel> depdetail = [];
      var depresponse = await http.get(
        Uri.parse("https://support.nctbutwal.com.np/api/departments/all"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final depdata = jsonDecode(depresponse.body)["data"];

      for (var u in depdata) {
        depdetail.add(DepartmentModel.fromJson(u));
      }

      if (mounted) {
        setState(() {
          userlist = detail;
          searchlist = detail;
          departmentlist = depdetail;
          isloading = false;
        });
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future createUser() async {
    try {
      setState(() {
        ishide = true;
      });
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/users/create";
      var body = {
        "department_id": deptype.id,
        "name": namecontroller.text,
        "email": emailcontroller.text,
        "mobile_no": mobilenumcontroller.text,
        "password": passwordcontroller.text
      };

      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          ishide = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sucessfully Created New User")));
      } else {
        setState(() {
          ishide = false;
        });
        final data = jsonDecode(response.body)["message"];
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data.toString())));
      }
    } catch (error) {
      print(error);
    }
  }

  List<UserModel> searchlist = [];
  void changeFuction(query) {
    final myList = query.isEmpty
        ? userlist
        : userlist
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
          title: const Text("Users"),
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
                      double bottom = MediaQuery.of(context).viewInsets.bottom;
                      return SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: bottom, left: 10, right: 10),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  const Center(
                                      child: Text(
                                    "Add User",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  const Text(
                                    'UserName',
                                    style: TextStyle(
                                        color: iconColor, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 17),
                                    keyboardType: TextInputType.multiline,
                                    controller: namecontroller,
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return 'field can\'t be empty ';
                                      }

                                      return null;
                                    }),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.person),
                                      hintText: 'Input Name',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Department Types',
                                    style: TextStyle(
                                        color: iconColor, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButtonFormField<
                                        DepartmentModel>(
                                      //isExpanded: false,
                                      hint:
                                          const Text('Select Department Types'),
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 8),
                                        border: InputBorder.none,
                                      ),

                                      value: deptype,
                                      onSaved: (value) {},
                                      isDense: true,
                                      onChanged: (value) {
                                        setState(() {
                                          deptype = value!;
                                        });
                                      },

                                      items: departmentlist.map((data) {
                                        return DropdownMenuItem<
                                            DepartmentModel>(
                                          value: data,
                                          child: Text(
                                              data.departmentname.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Mobile No',
                                    style: TextStyle(
                                        color: iconColor, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 17),
                                    keyboardType: TextInputType.multiline,
                                    controller: mobilenumcontroller,
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return 'field can\'t be empty ';
                                      }

                                      return null;
                                    }),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.phone),
                                      hintText: 'Mobile Number',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        color: iconColor, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 17),
                                    keyboardType: TextInputType.multiline,
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return 'field can\'t be empty ';
                                      }

                                      return null;
                                    }),
                                    controller: emailcontroller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.email),
                                      hintText: 'Email',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                        color: iconColor, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    style: const TextStyle(fontSize: 17),
                                    keyboardType: TextInputType.multiline,
                                    controller: passwordcontroller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.lock),
                                      hintText: 'Enter Password',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: iconColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          createUser();
                                        }
                                      },
                                      child: ishide
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator())
                                          : const Text(
                                              'Create',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
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
                        controller: usercontroller,
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
                                  usercontroller.clear();
                                });
                              },
                              icon: const Icon(Icons.close),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Search Users'),
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
                                    UserDetailPage(
                                  user: searchlist[index],
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
                                            .contact
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
                                  leading: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        searchlist[index]
                                            .profileImage
                                            .toString(),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: 22,
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    child: Center(
                                      child: SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.medal,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              searchlist[index]
                                                  .rewardPoints
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  title:
                                      Text(searchlist[index].name.toString()),
                                  subtitle: Text(
                                      searchlist[index].department.toString()),
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
