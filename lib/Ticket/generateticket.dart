import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nctserviceapp/component/problemsearchpage.dart';
import 'package:nctserviceapp/model/allinformationmodel.dart';
import 'package:nctserviceapp/model/prioritylistmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/organizationsearchpage.dart';
import '../component/usersearchpage.dart';

class GenerateTicket extends StatefulWidget {
  dynamic selectedProblemcategories;

  GenerateTicket({
    Key? key,
    this.selectedProblemcategories,
  }) : super(key: key);

  @override
  State<GenerateTicket> createState() => _GenerateTicketState();
}

TextEditingController problemcategoriesController = TextEditingController();
String? selectedproblemcategoryid;
bool isShow = false;
late File fileimage;
final List<File> _fileimages = [];
List images = [];

final _prioritylist = [
  PriorityList(5, "Highest"),
  PriorityList(4, "High"),
  PriorityList(3, "Medium"),
  PriorityList(2, "Low"),
  PriorityList(1, "Lowest"),
];

final _supporttype = ["Survey", "Call", "AnyDesk"];
List<AllInformationModel> createticket = [];
dynamic selecteduser;
TextEditingController usercontroller = TextEditingController();
bool isloading = false;
bool _orgerror = false;
bool _problemerror = false;

bool _supperror = false;
bool notifycustomer = true;
// String? _organization;
String? _problemname;

String? _problemcatname;

String? _description;
var _priority;
var product;

String? _supportname;
dynamic _selectedorganizationid;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _organizationController = TextEditingController();

class _GenerateTicketState extends State<GenerateTicket> {
  List<ProblemCategories> problemcategorylist = [];
  List<UsedProducts> usedProductList = [];
  final snackBar = const SnackBar(
    content: Text('The given data was invalid'),
  );
  final sucessmsg = const SnackBar(
    content: Text('sucessfully register'),
  );
  List<AllInformationModel> detail = [];

  void getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });
      detail = [];
      var response = await http
          .get(Uri.parse('https://support.nctbutwal.com.np/api/all-info'));
      final data = jsonDecode(response.body)['data'];

      for (var u in data) {
        detail.add(AllInformationModel.fromJson(u));
      }
      if (mounted) {
        setState(() {
          isloading = false;
          createticket = detail;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeTicket() async {
    try {
      setState(() {
        isloading = true;
      });
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/tickets/create";
      var body = {
        "organization_id": _selectedorganizationid,
        "product_id": product.id,
        "problem_type_id": _problemname,
        "problem_category_id": selectedproblemcategoryid,
        "assigned_to": selecteduser,
        "priority": _priority.value,
        "support_type": _supportname,
        "details": _description,
        "notify_customer": notifycustomer,
        "images": images
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      final result = jsonDecode(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: [
                    const Center(
                        child: Text(
                      "Ticket Alert",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(result["message"].toString()),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ));
      }
      if (response.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print(error);
    }
  }

  void pickimage() async {
    try {
      final pickedFile = await ImagePicker().pickMultiImage();
      if (pickedFile!.isNotEmpty) {
        for (var i = 0; i < pickedFile.length; i++) {
          _fileimages.add(File(pickedFile[i].path));
          File file = File(pickedFile[i].path);
          Uint8List bytes = file.readAsBytesSync();
          String pickedimage = base64Encode(bytes);
          images.add(pickedimage);
        }
      }

      setState(() {
        isShow = true;
      });
    } catch (error) {
      print(error);
    }
  }

  void pickimageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        Uint8List bytes = file.readAsBytesSync();
        String pickedimage = base64Encode(bytes);
        setState(() {
          isShow = true;

          _fileimages.add(file);
          images.add(pickedimage);
        });
      } else {}
    } catch (error) {
      print(error);
    }
  }

  void problemdispose() {
    problemcategoriesController.clear();
  }

  @override
  void initState() {
    super.initState();

    getDatafromApi();
    _orgerror = false;
    _problemerror = false;
    _supperror = false;
    notifycustomer = true;
    _selectedorganizationid = null;
    selecteduser = null;
    _priority = null;
    _supportname = null;
    isShow = false;
    _fileimages.clear();
  }

  @override
  void dispose() {
    super.dispose();

    _organizationController.clear();
    usercontroller.clear();
    problemcategoriesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text('Create Ticket'),
        backgroundColor: iconColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: !isloading
            ? Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Organization',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: TextFormField(
                                  controller: _organizationController,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    showDialog<void>(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return OrganizationSearchPage(
                                            data:
                                                createticket[0].organizations!,
                                            callback:
                                                (organizationname, id, list) {
                                              setState(() {
                                                _organizationController.text =
                                                    organizationname;
                                                usedProductList = list;
                                                _selectedorganizationid = id;
                                              });
                                            });
                                      },
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixIconConstraints:
                                        BoxConstraints(maxHeight: 20),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 10.0, right: 0.0),
                                    border: InputBorder.none,
                                    hintText: 'Select Organization',
                                  ),
                                )),
                            _orgerror
                                ? const Padding(
                                    padding:
                                        EdgeInsets.only(right: 225, top: 10),
                                    child: Text(
                                      'field can\'t be empty',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 201, 44, 44),
                                          fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Product',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonFormField<UsedProducts>(
                                //isExpanded: false,
                                hint: const Text('Select Product'),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  border: InputBorder.none,
                                ),

                                value: product,
                                onSaved: (value) {},
                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    product = value!;

                                    print(product.id);
                                  });
                                },

                                items: usedProductList.map((data) {
                                  return DropdownMenuItem<UsedProducts>(
                                    value: data,
                                    child: Text(data.name.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Asigned To',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: TextFormField(
                                  controller: usercontroller,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    showDialog<void>(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UserSearchPage(
                                            data: createticket[0].users!,
                                            callback: (username, id) {
                                              setState(() {
                                                usercontroller.text = username;

                                                selecteduser = id;
                                              });
                                            });
                                      },
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixIconConstraints:
                                        BoxConstraints(maxHeight: 20),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 10.0, right: 0.0),
                                    border: InputBorder.none,
                                    hintText: 'Select User',
                                  ),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Problem Types',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonFormField<ProblemTypes>(
                                isExpanded: true,
                                hint: const Text('Select Problems'),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // print(value);
                                  problemdispose();
                                  setState(() {
                                    _problemname = value!.id.toString();
                                    if (value.problemCategories!.isEmpty) {
                                      _problemcatname = '';
                                      problemcategorylist = [];
                                    } else {
                                      _problemcatname = value
                                          .problemCategories![0].id
                                          .toString();

                                      problemcategorylist =
                                          value.problemCategories!;
                                    }
                                  });
                                  //print(problemcategorylist[0].name);
                                },
                                items: createticket[0]
                                    .problemTypes!
                                    .map((ProblemTypes value) {
                                  return DropdownMenuItem<ProblemTypes>(
                                    value: value,
                                    child: Text(
                                      value.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            _problemerror
                                ? const Padding(
                                    padding:
                                        EdgeInsets.only(right: 225, top: 10),
                                    child: Text(
                                      'field can\'t be empty',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 201, 44, 44),
                                          fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Problem Categories',
                                  style:
                                      TextStyle(color: iconColor, fontSize: 18),
                                ),
                                Text(
                                  " (Optional)",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: TextFormField(
                                  controller: problemcategoriesController,
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    //print(widget.problemcategoriesController);
                                    showDialog<void>(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ProblemSearchPage(
                                            data: problemcategorylist,
                                            callback:
                                                (problemcategoryname, id) {
                                              setState(() {
                                                problemcategoriesController
                                                    .text = problemcategoryname;

                                                selectedproblemcategoryid = id;
                                              });
                                            });
                                      },
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixIconConstraints:
                                        BoxConstraints(maxHeight: 20),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 10.0, right: 0.0),
                                    border: InputBorder.none,
                                    hintText: 'Select Problems',
                                  ),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Priority',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonFormField<PriorityList>(
                                //isExpanded: false,
                                hint: const Text('Select Priority'),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  border: InputBorder.none,
                                ),

                                value: _priority,
                                onSaved: (value) {},
                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _priority = value!;
                                  });
                                },

                                items: _prioritylist.map((data) {
                                  return DropdownMenuItem<PriorityList>(
                                    value: data,
                                    child: Text(data.name.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Support Type',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonFormField(
                                //isExpanded: false,
                                hint: const Text('Select Support Type'),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  border: InputBorder.none,
                                ),

                                value: _supportname,

                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _supportname = value.toString();
                                    //print(_supportname);
                                  });
                                },

                                items: _supporttype.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            _supperror
                                ? const Padding(
                                    padding:
                                        EdgeInsets.only(right: 225, top: 10),
                                    child: Text(
                                      'field can\'t be empty',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 201, 44, 44),
                                          fontSize: 12),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'Upload Image',
                                  style:
                                      TextStyle(color: iconColor, fontSize: 18),
                                ),
                                Text(
                                  " (Optional)",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: IconButton(
                                    icon: const Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actions: [
                                                  const Center(
                                                    child: Text(
                                                      "Upload Picture",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Card(
                                                    color: primaryColor,
                                                    child: InkWell(
                                                      onTap: () {
                                                        pickimage();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: const [
                                                            Icon(
                                                              Icons.photo_album,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            Text(
                                                              '  Pick From Gallery',
                                                              style: TextStyle(
                                                                color:
                                                                    iconColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Card(
                                                    color: primaryColor,
                                                    child: InkWell(
                                                      onTap: () {
                                                        pickimageFromCamera();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: const [
                                                            Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            Text(
                                                              '  Pick From Camera',
                                                              style: TextStyle(
                                                                  color:
                                                                      iconColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                    },
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    color: Colors.white,
                                  ),
                                ),
                                isShow
                                    ? Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          height: 100,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _fileimages.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.file(
                                                      _fileimages[index],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Details',
                              style: TextStyle(color: iconColor, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              style: const TextStyle(fontSize: 17),
                              cursorHeight: 25,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              onSaved: (input) {
                                setState(() {
                                  _description = input;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8)),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Description',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
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
                        width: 8,
                      ),
                      const Text("Notify Customer")
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size(double.infinity, 40),
                      minimumSize: const Size(double.infinity, 40),
                      elevation: 2,
                      primary: iconColor,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_selectedorganizationid != null &&
                          _problemname != null &&
                          _supportname != null) {
                        _formKey.currentState!.save();

                        makeTicket();
                      } else {
                        if (_selectedorganizationid == null) {
                          setState(() {
                            _orgerror = true;
                          });
                        } else {
                          setState(() {
                            _orgerror = false;
                          });
                        }
                        if (_problemname == null) {
                          setState(() {
                            _problemerror = true;
                          });
                        } else {
                          setState(() {
                            _problemerror = false;
                          });
                        }

                        if (_supportname == null) {
                          setState(() {
                            _supperror = true;
                          });
                        } else {
                          setState(() {
                            _supperror = false;
                          });
                        }
                      }
                    },
                    child: const Text(
                      "Open Ticket",

                      // textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              )
            : const Padding(
                padding: EdgeInsets.only(top: 200),
                child: Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
