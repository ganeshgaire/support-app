import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nctserviceapp/Profile_Page/editprofile.dart';
import 'package:nctserviceapp/view/notificationpage.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/Internal_Task/internaltask.dart';

import 'package:nctserviceapp/view/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String? changedimage;
  bool isloading = true;
  bool isupdated = false;
  String? userimage;
  String? email;
  String? phonenumber;
  String? department;
  String? rewardpoints;
  File? imageFile;
  final imageupdate =
      const SnackBar(content: Text("Image updated successfully!"));
  void userdataread(value) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('userData');
    final data = jsonDecode(userData!);
    final String? profileimage = prefs.getString('profile_image');

    setState(() {
      name = data['name'];
      userimage = profileimage;
      email = data['email'];
      phonenumber = data['contact'];
      department = data['department'];
      rewardpoints = data['reward_points'];
      isloading = false;
      isupdated = value;
    });
  }

  void pickimage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        Uint8List bytes = file.readAsBytesSync();
        changedimage = base64Encode(bytes);
        changeImage();
        setState(() {
          imageFile = file;
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
        changedimage = base64Encode(bytes);
        changeImage();
      } else {
        print(pickedFile);
      }
    } catch (error) {
      print(error);
    }
  }

  Future changeImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/profile/change-image";
      var body = {
        "profile_image": changedimage.toString(),
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        prefs.remove('profile_image');
        ScaffoldMessenger.of(context).showSnackBar(imageupdate);
        var data = jsonDecode(response.body)["data"];

        prefs.setString('profile_image', data['profile_image']);
        final String? changedimg = prefs.getString('updatedimage');
        print(changedimg);
        setState(() {
          userimage = changedimg;
        });
        userdataread(isupdated);
      }
    } catch (error) {
      print(error);
    }
  }

  viewImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: SizedBox(
            height: 300,
            child: Image(image: NetworkImage(userimage.toString())),
          ));
        });
  }

  @override
  void initState() {
    userdataread(isupdated);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isloading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Stack(children: [
                      InkWell(
                        onTap: () {
                          viewImage(context);
                        },
                        child: Card(
                          borderOnForeground: false,
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(150),
                          ),
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)
                                //more than 50% of width makes circle
                                ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userimage.toString(),
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                      Positioned(
                        bottom: 14,
                        left: 130,
                        child: InkWell(
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3, color: Colors.white),
                                color: iconColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: SizedBox(
                        child: name.isEmpty
                            ? const CircularProgressIndicator()
                            : Text(name.toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textScaleFactor: 1.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Center(
                      child: SizedBox(
                        child: department!.isEmpty
                            ? const CircularProgressIndicator()
                            : Text(department.toString(),
                                style: const TextStyle(color: Colors.grey),
                                textScaleFactor: 1.2),
                      ),
                    ),
                  ),
                  Card(
                    color: iconColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Reward Points : ${rewardpoints.toString()}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        child: Text(
                          "My Profile ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Arial'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 314,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 60,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const EditProfile();
                                })).then((value) {
                                  if (value) {
                                    userdataread(value);
                                  }
                                });
                              },
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: const [
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 10.9,
                                        ),
                                        child: Icon(Icons.person)),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Edit Profile",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const InternalTask()));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.9,
                                      ),
                                      child: Icon(
                                        Icons.task,
                                        size: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'My Task',
                                        textScaleFactor: 1.6,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const NotificationPage()));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.9,
                                      ),
                                      child: Icon(
                                        Icons.notification_add,
                                        size: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Notification',
                                        textScaleFactor: 1.6,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          actions: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Center(
                                                child: Text(
                                                    "Do You Really Want To Logout?")),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: (() async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.clear();

                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const LoginPage()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  }),
                                                  child: const Text("Yes",
                                                      style: TextStyle(
                                                          color: Colors.green)),
                                                ),
                                                TextButton(
                                                  onPressed: (() async {
                                                    Navigator.pop(context);
                                                  }),
                                                  child: const Text("No",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ));
                              },
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.9,
                                      ),
                                      child: Icon(
                                        Icons.logout,
                                        size: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Log Out',
                                        textScaleFactor: 1.6,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.arrow_forward),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
