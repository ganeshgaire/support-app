import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nctserviceapp/Adimn_Management/organizationwiseticket.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import 'package:nctserviceapp/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({Key? key}) : super(key: key);

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  bool isloading = false;

  List<ProductModel> userlist = [];
  TextEditingController usercontroller = TextEditingController();

  Future<List<ProductModel>?> getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });

      List<ProductModel> detail = [];

      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse("https://support.nctbutwal.com.np/api/products/all"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body)["data"];

      for (var u in data) {
        detail.add(ProductModel.fromJson(u));
      }

      if (mounted) {
        setState(() {
          userlist = detail;
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

  List<ProductModel> searchlist = [];
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
          title: const Text("Products"),
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
                      return const AddProductPage();
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
                            hintText: 'Search Products'),
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
                            onTap: () {},
                            child: Slidable(
                              startActionPane: const ActionPane(
                                  extentRatio: 0.3,
                                  motion: StretchMotion(),
                                  children: []),
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
                                child: InkWell(
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
                                                        "Product Detail",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Center(
                                                    child: Card(
                                                      borderOnForeground: false,
                                                      elevation: 10.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(150),
                                                      ),
                                                      child: Container(
                                                        height: 80,
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)
                                                            //more than 50% of width makes circle
                                                            ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: Image.network(
                                                            searchlist[index]
                                                                .image
                                                                .toString(),
                                                            fit: BoxFit.fill,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
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
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Product Name',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .name
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Product Type',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .productType
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Product Description',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(searchlist[index]
                                                      .description
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
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    leading: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          searchlist[index].image.toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    title:
                                        Text(searchlist[index].name.toString()),
                                    subtitle: Text(searchlist[index]
                                        .productType
                                        .toString()),
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

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  List<ProductTypes> departmentlist = [];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroler = TextEditingController();
  bool isloading = false;
  bool ishide = false;
  String? productimage;
  File? productimagefile;
  String? hintetext = "Upload Image";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var producttype;
  Future<List<ProductTypes>?> getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });

      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      List<ProductTypes> typedetail = [];
      var typeresponse = await http.get(
        Uri.parse("https://support.nctbutwal.com.np/api/products/types"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final depdata = jsonDecode(typeresponse.body)["data"];

      for (var u in depdata) {
        typedetail.add(ProductTypes.fromJson(u));
      }
      if (mounted) {
        setState(() {
          departmentlist = typedetail;
          isloading = false;
        });
      }

      return typedetail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void pickimage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        Uint8List bytes = file.readAsBytesSync();
        productimage = base64Encode(bytes);

        setState(() {
          productimage = base64Encode(bytes);
          productimagefile = file;
          hintetext = "Image Uploaded Sucessfully";
        });
      }
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
        productimage = base64Encode(bytes);

        setState(() {
          productimage = base64Encode(bytes);
          hintetext = "Image Uploaded Sucessfully";
        });
      } else {}
    } catch (error) {
      print(error);
    }
  }

  Future createProduct() async {
    try {
      // print(selectedproblemcategoryid);
      setState(() {
        ishide = true;
      });
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/products/create";
      var body = {
        "product_type_id": producttype.id,
        "name": namecontroller.text,
        "description": descriptioncontroler.text,
        "image": productimage
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
          ishide = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sucessfully Added New Product")));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatafromApi();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return isloading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: const Center(child: CircularProgressIndicator()))
        : SizedBox(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom, left: 10, right: 10),
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
                        "Add Product",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      const Text(
                        'Product Name',
                        style: TextStyle(color: iconColor, fontSize: 18),
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
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 15, top: 10, bottom: 10),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Input Name',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Product Type',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: DropdownButtonFormField<ProductTypes>(
                          //isExpanded: false,
                          hint: const Text('Select Product Type'),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: InputBorder.none,
                          ),

                          value: producttype,
                          onSaved: (value) {},
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              producttype = value!;
                            });
                          },

                          items: departmentlist.map((data) {
                            return DropdownMenuItem<ProductTypes>(
                              value: data,
                              child: Text(data.name.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 17),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        controller: descriptioncontroler,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'field can\'t be empty ';
                          }

                          return null;
                        }),
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
                        height: 10,
                      ),
                      const Text(
                        'Upload Image',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      const Center(
                                        child: Text(
                                          "Change Your Profile Picture",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Card(
                                        color: Colors.amberAccent,
                                        child: InkWell(
                                          onTap: () {
                                            pickimage();
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.photo_album,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  '  Pick From Gallery',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        color: Colors.amberAccent,
                                        child: InkWell(
                                          onTap: () {
                                            pickimageFromCamera();
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  '  Pick From Camera',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                        style: const TextStyle(fontSize: 17),
                        keyboardType: TextInputType.none,
                        showCursor: false,
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
                          hintText: hintetext,
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: iconColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              createProduct();
                            }
                          },
                          child: ishide
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
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
  }
}

class ProductTypes {
  int? id;
  String? name;
  String? description;

  ProductTypes({this.id, this.name, this.description});

  ProductTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
