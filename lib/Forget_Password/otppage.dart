import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/Forget_Password/resetpassword.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  String? number;
  OtpPage({Key? key, this.number}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? token;
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();
  final notvalid = const SnackBar(
    content: Text('The number is invalid'),
  );
  final notexist = const SnackBar(
    content: Text('Number doesnot exit'),
  );
  bool ishide = false;
  Future resendotp() async {
    try {
      String url = "https://support.nctbutwal.com.np/api/password/forgot";
      var body = {
        "mobile_no": widget.number,
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      print(response.body);
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  Future checkotp() async {
    try {
      setState(() {
        ishide = true;
      });
      String url = "https://support.nctbutwal.com.np/api/otp/verify";
      var body = {
        "otp": otp1.text +
            otp2.text +
            otp3.text +
            otp4.text +
            otp5.text +
            otp6.text,
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body)["api_token"];

        setState(() {
          token = result;
          ishide = false;
        });

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ResetPasswordPage(
                  token: token,
                )));
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            const Text(
              'Pleasse enter your verification code',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'We have sent a verification code to  ${widget.number} ',
              style: const TextStyle(
                color: Color.fromARGB(255, 141, 139, 139),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 60,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextFormField(
                        controller: otp1,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextFormField(
                        controller: otp2,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextFormField(
                        controller: otp3,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextFormField(
                        controller: otp4,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextFormField(
                        controller: otp5,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: TextFormField(
                        controller: otp6,
                        autofocus: true,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        showCursor: false,
                        readOnly: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black12),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  )
                ],
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
                  checkotp();
                },
                child: ishide
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : const Text(
                        'Verify',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Didn't you receive any code?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 18,
            ),
            InkWell(
              onTap: () {
                resendotp();
              },
              child: const Text(
                "Resend New Code",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
