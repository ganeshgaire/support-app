import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nctserviceapp/Adimn_Management/organizationwiseticket.dart';
import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/model/liscensedetailmodel.dart';
import 'package:nctserviceapp/model/organizationmodel.dart';
import 'package:http/http.dart' as http;

class OrganizationDetail extends StatefulWidget {
  OrganizationListModel organization;
  OrganizationDetail({Key? key, required this.organization}) : super(key: key);

  @override
  State<OrganizationDetail> createState() => _OrganizationDetailState();
}

class _OrganizationDetailState extends State<OrganizationDetail> {
  List<Marker> markers = <Marker>[];

  void marker() {
    double latitude = double.parse(widget.organization.latitude!);
    double longitude = double.parse(widget.organization.longitude!);
    String? name = widget.organization.name.toString();
    String? address = widget.organization.address.toString();
    Marker marker = Marker(
      markerId: const MarkerId("121"),
      position: LatLng(latitude, longitude),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: name,
        snippet: address,
      ),
    );
    markers.add(marker);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marker();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text("Organization Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: height / 2.2,
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: markers.toSet(),
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.organization.latitude!),
                      double.parse(widget.organization.longitude!)),
                  zoom: 15.4746,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organization :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.organization.name.toString(),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<dynamic>(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) {
                                  return LicenseDetailPage(
                                    panvat: widget.organization.panVatNo,
                                  );
                                });
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.key,
                                color: Colors.blue,
                              ),
                              Text(
                                "View Liscense Detail",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Type :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.organization.type.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Representative Name',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.organization.representativeName.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.organization.address.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Mobile Number :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.organization.mobileNo.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Used Product :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.organization.usedProducts!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(widget
                                .organization.usedProducts![index].name
                                .toString()),
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'PanVat Number :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(widget.organization.panVatNo.toString()),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          primary: iconColor,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OrganizationWiseTicket(
                                    orgid: widget.organization.id!,
                                    orgname: widget.organization.name!,
                                  )));
                        },
                        child: const Text(
                          "View Tickets",

                          // textScaleFactor: 1.2,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LicenseDetailPage extends StatefulWidget {
  String? panvat;
  LicenseDetailPage({Key? key, this.panvat}) : super(key: key);

  @override
  State<LicenseDetailPage> createState() => _LicenseDetailPageState();
}

class _LicenseDetailPageState extends State<LicenseDetailPage> {
  bool isEmpty = false;
  List<LiscenseDetailModel> liscensedetail = [];
  bool isloading = false;
  Future getLicenseDetail() async {
    try {
      setState(() {
        isloading = true;
      });
      List<LiscenseDetailModel> detail = [];

      String url =
          "https://server-restroms.nctbutwal.com.np/api/support-app/v1/restaurant/license/details";
      var body = {"pan_vat_no": widget.panvat};

      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'api_key':
            'SUPPORTAPPVs6KSWeJztptlu9rEYeRweVGxDwn5r1GuaHrofpRBnS4plSpqCP1YJ',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      print(response.statusCode);

      if (response.statusCode == 200 && mounted) {
        final data = [jsonDecode(response.body)["data"]];
        setState(() {
          isloading = false;
        });
        for (var u in data) {
          detail.add(LiscenseDetailModel.fromJson(u));
        }
        setState(() {
          liscensedetail = detail;
        });
      }
      if (response.statusCode == 403) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              " License Not Assigned",
            )));
      }
      if (response.statusCode == 204) {
        setState(() {
          isloading = false;
          isEmpty = true;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLicenseDetail();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return isloading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(child: CircularProgressIndicator()))
        : isEmpty
            ? const SizedBox(
                height: 300,
                child: Center(
                    child: Text(
                  "No Data Found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )))
            : SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom, left: 10, right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        liscensedetail[0].restaurantName.toString() +
                            " License Detail",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'License Name',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Text(
                                liscensedetail[0]
                                    .licenseRemainingTime
                                    .toString(),
                                style: TextStyle(
                                    color: liscensedetail[0].licenseStatus == 1
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              liscensedetail[0].licenseStatus == 1
                                  ? const Text(
                                      " Remaining",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(liscensedetail[0].licenseName.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'License Serial Key',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(liscensedetail[0].licenseSerialKey.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'License Expiry Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(liscensedetail[0].licenseExpiryDate.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Server Type',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(liscensedetail[0].serverType.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'License Created Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(liscensedetail[0].licenseCreatedOn.toString()),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
  }
}
