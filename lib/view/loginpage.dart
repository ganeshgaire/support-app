import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import 'package:nctserviceapp/view/mainpage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Forget_Password/forgetpass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String devicetoken =
      "eEcu_X4XMkspr7fsv6IlrL:APA91bFcUP60TtS7Nf-WMBhpxhFbXLuzYvVmo6e7Iczct6oNH3XUFrM1k0J2sr5pkQ-RGbF7Sssf7JWY5CZnEiApFnq5lvj4MajFpKZ7aqr32Jzxn1IR6W_zoJO7-vl-163q3xnEQ9QS";
  final snackBar = const SnackBar(
    content: Text('Email or  password incorrect'),
  );
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isApiCallProcess = false;

  Future login() async {
    try {
      setState(() {
        isApiCallProcess = true;
      });
      await Firebase.initializeApp();
      final FirebaseMessaging _fcm = FirebaseMessaging.instance;

      final devicetoken = await _fcm.getToken();
      final prefs = await SharedPreferences.getInstance();
      var headers = {'Accept': 'application/json'};
      String url = baseurl + "login";
      var body = {
        "username": emailcontroller.text,
        "password": passwordcontroller.text,
        "device_token":
            "eEcu_X4XMkspr7fsv6IlrL:APA91bFcUP60TtS7Nf-WMBhpxhFbXLuzYvVmo6e7Iczct6oNH3XUFrM1k0J2sr5pkQ-RGbF7Sssf7JWY5CZnEiApFnq5lvj4MajFpKZ7aqr32Jzxn1IR6W_zoJO7-vl-163q3xnEQ9QS"
      };
      print(devicetoken);
      final response = await http.post(
        Uri.parse(
          url,
        ),
        headers: headers,
        body: body,
      );
      response.headers.addAll(headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];

        final token = jsonDecode(response.body)["api_token"];

        final userData = jsonEncode(data);

        prefs.setBool('islogin', true);
        prefs.setString('user_type', data["user_type"]);
        prefs.setString('token', token);
        prefs.setString('userData', userData);
        prefs.setString('profile_image', data["profile_image"]);

        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Mainpage()),
            (route) => false);
      } else {
        setState(() {
          isApiCallProcess = false;
          passwordcontroller.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getdevicetoken() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isApiCallProcess
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/logo.png'))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: emailcontroller,
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'field can\'t be empty ';
                              }

                              return null;
                            }),
                            decoration: InputDecoration(
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
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  212,
                                  221,
                                  227,
                                ),
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                hintText: 'Email'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordcontroller,
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'field can\'t be empty ';
                              }
                              return null;
                            }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  212,
                                  221,
                                  227,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(
                                      255,
                                      212,
                                      221,
                                      227,
                                    ),
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                hintText: 'Password'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
                ElevatedButton(
                  autofocus: true,
                  style: ElevatedButton.styleFrom(
                      primary: iconColor,
                      maximumSize: Size(width * 0.6, 40),
                      minimumSize: Size(width * 0.6, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    if (validateAndSave()) {
                      login();
                    }
                  },
                  child: const Text(
                    'Log in ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (() {
                    showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return const ForgetpassPage();
                        });
                  }),
                  child: const Text(
                    'Forget Password',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
