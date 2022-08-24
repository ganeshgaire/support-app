import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/Profile_Page/changepassword.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isUpdate = false;
  String? name;

  bool isloading = false;

  String? email;
  String? phonenumber;
  String? address = "";
  TextEditingController? namecontroller;
  TextEditingController? addresscontroler;
  TextEditingController? emailcontroller;
  TextEditingController? contactcontroller;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final updateSnackbar =
      const SnackBar(content: Text("Profile updated successfully!"));
  final unauthorizedSnackbar = const SnackBar(content: Text("Unauthorized"));
  final validationSnackbar =
      const SnackBar(content: Text("All field are required!"));
  void userdataread() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString('userData');
      final data = jsonDecode(userData!);

      setState(() {
        name = data['name'];

        email = data['email'];
        phonenumber = data['contact'];
        address = data['address'];

        namecontroller = TextEditingController(
          text: name!.isNotEmpty ? name : "",
        );
        emailcontroller = TextEditingController(
          text: email!.isNotEmpty ? email : "",
        );
        contactcontroller = TextEditingController(
          text: phonenumber!.isNotEmpty ? phonenumber : "",
        );
        addresscontroler = TextEditingController(
          text: address,
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future editData() async {
    try {
      setState(() {
        isloading = true;
      });
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/profile/update";
      var body = {
        "name": namecontroller!.text,
        "contact": contactcontroller!.text,
        "address": addresscontroler!.text
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      print("hello ${response.statusCode}");
      if (response.statusCode == 200) {
        prefs.remove('userData');
        var data = jsonDecode(response.body);

        prefs.setString('userData', jsonEncode(data['data']));

        ScaffoldMessenger.of(context).showSnackBar(updateSnackbar);

        Navigator.of(context).pop(true);
      }
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(unauthorizedSnackbar);
      }
      if (response.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(validationSnackbar);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    userdataread();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: iconColor,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(isUpdate);
                },
                child: const Icon(Icons.arrow_back)),
            centerTitle: true,
            title: const Text('Update Profile'),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'field can\'t be empty ';
                                }
                                return null;
                              }),
                              cursorColor: Colors.grey,
                              controller: namecontroller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.edit),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                label: Text('Full Name',
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'field can\'t be empty ';
                                }
                                return null;
                              }),
                              cursorColor: Colors.grey,
                              controller: addresscontroler,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.edit),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                label: Text('Address',
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: emailcontroller,
                              enabled: false,
                              readOnly: true,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                label: Text('Email',
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'field can\'t be empty ';
                                }
                                if (value.length != 10) {
                                  return 'Mobile Number must be of 10 digit ';
                                }

                                return null;
                              }),
                              cursorColor: Colors.grey,
                              controller: contactcontroller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.edit),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                label: Text('Mobile Number',
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    context: context,
                                    builder: (context) {
                                      return const ChangePasswordPage();
                                    });
                              },
                              child: TextFormField(
                                autofocus: false,
                                enabled: false,
                                showCursor: false,
                                keyboardType: TextInputType.none,
                                initialValue: "Tap Here To Change Password",
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(Icons.edit),
                                  // isDense: true,

                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 14),
                                  label: Text('Password',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: iconColor),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            if (!isloading) {
                              editData();
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          child: !isloading
                              ? const Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ))
                  ],
                ),
              )),
            ),
          )),
    );
  }
}
