import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:http/http.dart' as http;

import '../view/loginpage.dart';

class ResetPasswordPage extends StatefulWidget {
  String? token;
  ResetPasswordPage({Key? key, this.token}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool ishide = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController repasswordcontroller = TextEditingController();
  Future resetPassword() async {
    try {
      setState(() {
        ishide = true;
      });
      String url = "https://support.nctbutwal.com.np/api/password/reset";
      var body = {"password": repasswordcontroller.text};
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer ${widget.token}}',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        setState(() {
          ishide = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reset Password Sucessfully")));
      } else {
        setState(() {
          ishide = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reset Password Failed")));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            const Icon(
              Icons.lock_open,
              size: 100,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Create New Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Your new password must be different from \n             previously used passwords.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
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
                            hintText: 'Password'),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: iconColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          if (validateAndSave()) {
                            resetPassword();
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
                )),
          ],
        ),
      ),
    ));
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
