import 'package:flutter/material.dart';
import 'package:nctserviceapp/Adimn_Management/licensemanagement.dart';
import 'package:nctserviceapp/Adimn_Management/product_management.dart';
import 'package:nctserviceapp/Adimn_Management/user_management.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/Adimn_Management/organization_managent.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text("Admin Management"),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          children: [
            InkWell(
              onTap: (() {
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) {
                    return const OrganizationList();
                  }),
                ));
              }),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/comp.png',
                      height: 110,
                    ),
                    const Center(
                      child: Text(
                        'Organization Management',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (() {
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) {
                    return const UserManagementPage();
                  }),
                ));
              }),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.person,
                      size: 110,
                      color: iconColor,
                    ),
                    Text(
                      'User Management',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (() {
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) {
                    return const ProductManagementPage();
                  }),
                ));
              }),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.computer_outlined,
                      size: 110,
                      color: iconColor,
                    ),
                    Center(
                      child: Text(
                        'Product Management',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (() {
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) {
                    return const LicenseManagementPage();
                  }),
                ));
              }),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.key,
                      size: 110,
                      color: iconColor,
                    ),
                    Text(
                      'License Management',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
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
