import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../view/loginpage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool ishide = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldpasswordcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController repasswordcontroller = TextEditingController();
  Future changePassword() async {
    try {
      setState(() {
        ishide = true;
      });
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/password/change";
      var body = {
        "old_password": oldpasswordcontroller.text,
        "new_password": repasswordcontroller.text
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token}',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        Navigator.pop(context);
        setState(() {
          ishide = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 245),
            content: Text(
              " Password Changed Failed",
            )));
        prefs.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
      }
      if (response.statusCode == 404) {
        setState(() {
          ishide = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 245),
            content: Text(
              " Password Doesnot Match",
            )));
      } else if (response.statusCode == 401) {
        setState(() {
          ishide = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 245),
            content: Text(
              " Password Changed Failed",
            )));
        prefs.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          ishide = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              " Password Changed Failed",
            )));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom, left: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              width: 60,
              child: Divider(
                thickness: 4,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Change Your Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Your new password must be different from \npreviously used passwords.",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: oldpasswordcontroller,
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
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'Current Password'),
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
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'New Password'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: repasswordcontroller,
                    validator: ((value) {
                      if (value != passwordcontroller.text) {
                        return 'Re-Password does not match';
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
                        hintText: 'Re-enter Password'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: iconColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  changePassword();
                }
              },
              child: ishide
                  ? const SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator())
                  : const Text(
                      'Change',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
