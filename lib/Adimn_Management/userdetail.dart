import 'package:flutter/material.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import '../model/usermodel.dart';

class UserDetailPage extends StatefulWidget {
  UserModel user;
  UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  TextEditingController? namecontroller;
  TextEditingController? addresscontroler;
  TextEditingController? emailcontroller;
  TextEditingController? departmentcontroller;
  TextEditingController? joineddatecontroller;

  TextEditingController? contactcontroller;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  viewImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: SizedBox(
            height: 300,
            child:
                Image(image: NetworkImage(widget.user.profileImage.toString())),
          ));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller = TextEditingController(
      text: widget.user.name,
    );
    addresscontroler = TextEditingController(
      text: widget.user.address,
    );
    emailcontroller = TextEditingController(
      text: widget.user.email,
    );
    contactcontroller = TextEditingController(
      text: widget.user.contact,
    );
    departmentcontroller = TextEditingController(
      text: widget.user.department,
    );
    joineddatecontroller = TextEditingController(
      text: widget.user.joinedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: iconColor,
        title: Text(widget.user.name.toString() + "'s Profile"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)
                            //more than 50% of width makes circle
                            ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        widget.user.profileImage.toString(),
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Card(
            color: iconColor,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Reward Points : ${widget.user.rewardPoints.toString()}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
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
                  TextFormField(
                    controller: departmentcontroller,
                    enabled: false,
                    readOnly: true,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 14),
                      label: Text('Department',
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
                    controller: joineddatecontroller,
                    enabled: false,
                    readOnly: true,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 14),
                      label: Text('Joined Date',
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
