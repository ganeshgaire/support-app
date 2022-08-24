import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:http/http.dart' as http;
import 'otppage.dart';

class ForgetpassPage extends StatefulWidget {
  const ForgetpassPage({Key? key}) : super(key: key);

  @override
  State<ForgetpassPage> createState() => _ForgetpassPageState();
}

class _ForgetpassPageState extends State<ForgetpassPage> {
  final notvalid = const SnackBar(
    content: Text('The number is invalid'),
  );
  final notexist = const SnackBar(
    content: Text('Number doesnot exit'),
  );
  bool ishide = false;
  TextEditingController phonenumber = TextEditingController();
  Future forgetpassword() async {
    try {
      setState(() {
        ishide = true;
      });
      String url = "https://support.nctbutwal.com.np/api/password/forgot";
      var body = {
        "mobile_no": phonenumber.text,
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
      };
      print(phonenumber.text);
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          ishide = false;
        });
        showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            context: context,
            builder: (context) {
              return OtpPage(
                number: phonenumber.text,
              );
            });
      }
      if (response.statusCode == 422) {
        setState(() {
          ishide = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(notvalid);
      } else if (response.statusCode == 400) {
        setState(() {
          ishide = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(notexist);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Icon(
                Icons.lock,
                size: 50,
              ),
              const Text(
                "Forget Your Password?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'We will send a verification code to ',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const Text(
                'your registered phone number',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                  controller: phonenumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      isDense: true, // important line
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Enter Your Phone Number '),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: iconColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      forgetpassword();
                    },
                    child: ishide
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : const Text(
                            'Send',
                            style: TextStyle(fontSize: 18),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
