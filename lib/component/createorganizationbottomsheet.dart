import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:http/http.dart' as http;
import 'package:nctserviceapp/model/productmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/organizationtypemodel.dart';
import 'maps.dart';

class CreateOrgBottomSheet extends StatefulWidget {
  const CreateOrgBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateOrgBottomSheet> createState() => _CreateOrgBottomSheetState();
}

class _CreateOrgBottomSheetState extends State<CreateOrgBottomSheet> {
  bool ishide = false;
  bool isloading = false;
  TextEditingController organizationtypecontroller = TextEditingController();
  TextEditingController orgnamecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController repnamecontroller = TextEditingController();
  TextEditingController panvatcontroller = TextEditingController();
  TextEditingController mobnumcontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var orgtype;

  String? lattitude;
  String? longitude;
  List<OrganizationTypeModel> organizationtypelist = [];
  List usedProductList = [];
  List usedProductIndexes = [];
  final Set<Marker> _markers = {};
  Future<List<OrganizationTypeModel>?> getDatafromApi() async {
    try {
      setState(() {
        isloading = true;
      });

      List<OrganizationTypeModel> detail = [];

      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse("https://support.nctbutwal.com.np/api/organizations/types"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body)["data"];
      for (var u in data) {
        detail.add(OrganizationTypeModel.fromJson(u));
      }

      if (mounted) {
        setState(() {
          organizationtypelist = detail;

          isloading = false;
        });
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future createOrganization() async {
    try {
      // print(selectedproblemcategoryid);
      setState(() {
        ishide = true;
      });
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/organizations/create";
      var body = {
        "organization_type_id": orgtype.id,
        "organization_name": orgnamecontroller.text,
        "address": addresscontroller.text,
        "mobile_no": mobnumcontroller.text,
        "phone_no": phonenumbercontroller.text,
        "representative_name": repnamecontroller.text,
        "used_products": usedProductIndexes,
        "pan_vat_no": panvatcontroller.text,
        "latitude": lattitude,
        "longitude": longitude
      };
      print(body);
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sucessfully Created New Organization")));
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
            height: MediaQuery.of(context).size.height * 0.96,
            child: const Center(child: CircularProgressIndicator()))
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.96,
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
                        height: 12,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.cancel_rounded)),
                      const Center(
                          child: Text(
                        "Add Organization",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      const Text(
                        'Organization Name',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 17),
                        keyboardType: TextInputType.multiline,
                        controller: orgnamecontroller,
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
                          prefixIcon: const Icon(Icons.house_outlined),
                          hintText: 'Organization',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Organization Types',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: DropdownButtonFormField<OrganizationTypeModel>(
                          //isExpanded: false,
                          hint: const Text('Select Organization Types'),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: InputBorder.none,
                          ),

                          value: orgtype,
                          onSaved: (value) {},
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              orgtype = value!;
                              print(orgtype.id);
                            });
                          },

                          items: organizationtypelist.map((data) {
                            return DropdownMenuItem<OrganizationTypeModel>(
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
                        'Used Products',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: UsedProductPage(
                                    callback: (list, listindex) {
                                      setState(() {
                                        usedProductList = list;
                                        usedProductIndexes = listindex;
                                      });
                                    },
                                  ),
                                );
                              });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextFormField(
                              enabled: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                label: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(usedProductList.toString(),
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Address',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 17),
                        keyboardType: TextInputType.multiline,
                        controller: addresscontroller,
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
                          prefixIcon: const Icon(Icons.navigation),
                          hintText: 'Address',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Representative Name',
                        style: TextStyle(color: iconColor, fontSize: 18),
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
                        controller: repnamecontroller,
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
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Representative Name',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text(
                            'Phone Number',
                            style: TextStyle(color: iconColor, fontSize: 18),
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
                      TextFormField(
                        style: const TextStyle(fontSize: 17),
                        keyboardType: TextInputType.multiline,
                        controller: phonenumbercontroller,
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
                          prefixIcon: const Icon(Icons.phone),
                          hintText: 'Enter Phone Number',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Mobile Number',
                        style: TextStyle(color: iconColor, fontSize: 18),
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
                        controller: mobnumcontroller,
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
                          prefixIcon: const Icon(Icons.phone_android),
                          hintText: 'Enter Mobile Number',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'PAN_VAT Number',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 17),
                        keyboardType: TextInputType.multiline,
                        controller: panvatcontroller,
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
                          prefixIcon: const Icon(Icons.note_add),
                          hintText: 'Enter PAN_VAT Number',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Set a Location!',
                        style: TextStyle(color: iconColor, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return OrganizationMap(
                                      callback: (p0, p1) {
                                        setState(() {
                                          lattitude = p0;
                                          longitude = p1;
                                          _markers.clear();
                                          _markers.add(Marker(
                                              markerId: const MarkerId("1"),
                                              position: LatLng(
                                                  double.parse(lattitude!),
                                                  double.parse(longitude!))));
                                        });
                                      },
                                    );
                                  });
                            },
                            child: const Icon(
                              Icons.fullscreen,
                              size: 36,
                            ),
                          )),
                      SizedBox(
                        height: 400,
                        child: GoogleMap(
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          markers: _markers,
                          onTap: (pos) {
                            setState(() {
                              lattitude = pos.latitude.toString();
                              longitude = pos.longitude.toString();
                              _markers.clear();
                              _markers.add(Marker(
                                markerId: const MarkerId("id-1"),
                                position: pos,
                              ));
                              // print(_markers);
                            });
                          },
                          onMapCreated: (GoogleMapController controller) {},
                          mapType: MapType.normal,
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(27.6866, 83.4323),
                            zoom: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: iconColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              createOrganization();
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

class UsedProductPage extends StatefulWidget {
  final Function(List, List) callback;
  const UsedProductPage({Key? key, required this.callback}) : super(key: key);

  @override
  State<UsedProductPage> createState() => _UsedProductPageState();
}

class _UsedProductPageState extends State<UsedProductPage> {
  List usedProductList = [];
  List usedProductIndexes = [];
  List<ProductModel> productList = [];
  bool isloading = false;
  getUsedProductData() async {
    setState(() {
      isloading = true;
    });

    List<ProductModel> productDetail = [];

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
      productDetail.add(ProductModel.fromJson(u));
    }
    if (response.statusCode == 200) {
      setState(() {
        isloading = false;
        productList = productDetail;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsedProductData();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Container(
            height: 200,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(productList[index].name.toString()),
                    autofocus: false,
                    checkColor: Colors.white,
                    selected: false,
                    value: productList[index].isChecked,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          productList[index].isChecked = value;
                          usedProductList
                              .add(productList[index].name.toString());
                          usedProductIndexes.add(productList[index].id);
                          widget.callback(usedProductList, usedProductIndexes);
                        } else if (value == false) {
                          productList[index].isChecked = value;

                          usedProductList.remove(productList[index].name);
                          usedProductIndexes.remove(productList[index].id);
                          widget.callback(usedProductList, usedProductIndexes);
                        }
                      });
                    },
                  );
                }),
          );
  }
}
