import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nctserviceapp/component/constantcolor.dart';
import 'package:nctserviceapp/component/organizationsearchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/signaturepage.dart';

import 'package:http/http.dart' as http;

import '../model/allinformationmodel.dart';
import '../model/surveyquestionmodel.dart';

class CreateSurveyPage extends StatefulWidget {
  const CreateSurveyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateSurveyPage> createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  List<CompanyRecommendationModel> companyrecomlist = [];
  CompanyRecommendationModel? comprecRadio;
  String? comopanyrecom;
  List<CompanySatisfaction> companysatnlist = [];
  CompanySatisfaction? compsatfnRadio;
  String? compsatfn;
  List<ProductDescriptionModel> productDescList = [];
  ProductDescriptionModel? productDescRadio;
  List productDesc = [];
  List<MeetsCustomerNeeds> meetscustmlist = [];
  MeetsCustomerNeeds? meetscustmRadio;
  String? meetscustm;
  List<ProductQualityModel> productquallist = [];
  ProductQualityModel? productqualRadio;
  String? productqual;
  List<ProductValuabilityModel> productvaluelist = [];
  ProductValuabilityModel? productvalueRadio;
  String? productvalue;
  List<CustomerServiceModel> customerservicelist = [];
  CustomerServiceModel? customerserviceRadio;
  String? customerservice;
  List<ProductUsageSinceModel> usersincelist = [];
  ProductUsageSinceModel? usersinceRadio;
  String? usersince;
  List<WantOtherProductsModel> wantotherproductlist = [];
  WantOtherProductsModel? wantotherproductRadio;
  String? wantotherproduct;

  late File fileimage;
  final List<File> _fileimages = [];
  List images = [];

  dynamic _selectedorganizationid;
  String? image = "";

  Uint8List? imageBytes;
  String? signatureimage;
  String? latitude;
  String? longitude;
  List<AllInformationModel> organizationlist = [];

  bool orgerror = false;
  bool isShow = false;
  bool isloading = false;
  bool isscrolled = true;

  TextEditingController feedbackcontroler = TextEditingController();
  TextEditingController representativecontroller = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final snackBar = const SnackBar(
    content: Text('Please fill all fields'),
  );
  final sucessmsg = const SnackBar(
    content: Text('sucessfully created survey'),
  );

  Future createSurvey() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print(representativecontroller.text);

      print(feedbackcontroler.text);
      final String? token = prefs.getString('token');
      String url = "https://support.nctbutwal.com.np/api/surveys/create";
      var body = {
        "organization_id": _selectedorganizationid,
        "representative_name": representativecontroller.text,
        "feedback": {
          "company_recommendation": comopanyrecom,
          "company_satisfaction": compsatfn,
          "product_description": productDesc,
          "meets_customer_needs": meetscustm,
          "product_quality": productqual,
          "product_valuability": productvalue,
          "customer_service": customerservice,
          "product_usage_since": usersince,
          "want_other_products": wantotherproduct,
          "feedback": feedbackcontroler.text
        },
        "latitude": latitude,
        "longitude": longitude,
        "signature_image": signatureimage,
        "images": images
      };
      var headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(sucessmsg);
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print(error);
    }
  }

  void getDatafromApi() async {
    try {
      List<AllInformationModel> detail = [];
      setState(() {
        isloading = true;
      });

      var response = await http.get(Uri.parse(baseurl + 'all-info'));
      final data = jsonDecode(response.body)['data'];
      //print(response.body);
      for (var u in data) {
        detail.add(AllInformationModel.fromJson(u));
      }

      if (mounted) {
        setState(() {
          isloading = false;
          organizationlist = detail;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  const Center(
                      child: Text(
                    "Permission Alert",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                      child: Text(
                          "Allow NCTsupport app to access this device's location")),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: (() async {
                            await Geolocator.openLocationSettings()
                                .then((value) => Navigator.pop(context));
                          }),
                          child: const Text("Allow",
                              style: TextStyle(color: Colors.green)),
                        ),
                        TextButton(
                          onPressed: (() async {
                            Navigator.pop(context);
                          }),
                          child: const Text("Deny",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  )
                ],
              ));

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: [
                    const Center(
                        child: Text(
                      "Permission Alert",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                        child: Text(
                            "You cannot create survey until you allow us to open location")),
                    TextButton(
                      onPressed: (() async {
                        Navigator.pop(context);
                      }),
                      child: const Text("Ok",
                          style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ));

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  const Center(
                      child: Text(
                    "Permission Alert",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                      child: Text(
                          "Location permissions are permanently denied, we cannot request permissions.")),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Ok",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ));
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var a = await Geolocator.getCurrentPosition();
    setState(() {
      longitude = a.longitude.toString();
      latitude = a.latitude.toString();
    });

    return a;
  }

  void pickimage() async {
    try {
      final pickedFile = await ImagePicker().pickMultiImage();
      if (pickedFile!.isNotEmpty) {
        for (var i = 0; i < pickedFile.length; i++) {
          _fileimages.add(File(pickedFile[i].path));
          File file = File(pickedFile[i].path);
          Uint8List bytes = file.readAsBytesSync();
          String pickedimage = base64Encode(bytes);
          images.add(pickedimage);
        }
      }

      setState(() {
        isShow = true;
      });
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
        String pickedimage = base64Encode(bytes);
        setState(() {
          isShow = true;

          _fileimages.add(file);
          images.add(pickedimage);
        });
      } else {}
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getDatafromApi();
    getLocation();

    companyrecomlist = CompanyRecommendationModel.companyrecomlist;
    companysatnlist = CompanySatisfaction.companysatnlist;
    productDescList = ProductDescriptionModel.productDescList;
    meetscustmlist = MeetsCustomerNeeds.meetscustmlist;
    productquallist = ProductQualityModel.productquallist;
    productvaluelist = ProductValuabilityModel.productvaluelist;
    customerservicelist = CustomerServiceModel.customerservicelist;
    usersincelist = ProductUsageSinceModel.usersincelist;
    wantotherproductlist = WantOtherProductsModel.wantotherproductlist;

    for (var i = 0; i < ProductDescriptionModel.productDescList.length; i++) {
      ProductDescriptionModel.productDescList[i].ischecked = false;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _organizationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          backgroundColor: iconColor,
          title: const Text("Create Survey"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
              physics: isscrolled
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: !isloading
                  ? Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Organization',
                            style: TextStyle(color: iconColor, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                controller: _organizationController,
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  showDialog<void>(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return OrganizationSearchPage(
                                          data: organizationlist[0]
                                              .organizations!,
                                          callback:
                                              (organizationname, id, list) {
                                            setState(() {
                                              getLocation();
                                              _organizationController.text =
                                                  organizationname;

                                              _selectedorganizationid = id;
                                            });
                                          });
                                    },
                                  );
                                },
                                decoration: const InputDecoration(
                                  suffixIconConstraints:
                                      BoxConstraints(maxHeight: 20),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.zero,
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 10.0, right: 0.0),
                                  border: InputBorder.none,
                                  hintText: 'Select Organization',
                                ),
                              )),
                          orgerror
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 225, top: 10),
                                  child: Text(
                                    'field can\'t be empty',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 201, 44, 44),
                                        fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Representative Name',
                            style: TextStyle(color: iconColor, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'field can\'t be empty ';
                              }

                              return null;
                            }),
                            style: const TextStyle(fontSize: 17),
                            cursorHeight: 25,
                            keyboardType: TextInputType.multiline,
                            maxLines: 1,
                            controller: representativecontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Type a Name',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              " How likely is it that you would recommend this company to a friend or colleague?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: companyrecomlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: comprecRadio,
                                    autofocus: false,
                                    title: Text(companyrecomlist[index]
                                        .name
                                        .toString()),
                                    value: companyrecomlist[index],
                                    onChanged:
                                        (CompanyRecommendationModel? value) {
                                      setState(() {
                                        comprecRadio = value;
                                        comopanyrecom = companyrecomlist[index]
                                            .name
                                            .toString();
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              " Overall, how satisfied or dissatisfied are you with our company?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: companysatnlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: compsatfnRadio,
                                    autofocus: false,
                                    title: Text(
                                        companysatnlist[index].name.toString()),
                                    value: companysatnlist[index],
                                    onChanged: (CompanySatisfaction? value) {
                                      setState(() {
                                        compsatfnRadio = value;
                                        compsatfn = companysatnlist[index]
                                            .name
                                            .toString();
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "Which of the following words you use to describe our products? Select all that apply.",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ProductDescriptionModel
                                    .productDescList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(ProductDescriptionModel
                                        .productDescList[index].name
                                        .toString()),
                                    autofocus: false,
                                    checkColor: Colors.white,
                                    selected: false,
                                    value: productDescList[index].ischecked,
                                    onChanged: (value) {
                                      setState(() {
                                        productDescList[index].ischecked =
                                            value!;
                                        productDesc.add(productDescList[index]
                                            .name
                                            .toString());
                                        if (value = false) {
                                          productDesc.remove(
                                              productDescList[index]
                                                  .name
                                                  .toString());
                                        }
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "How well do our products meet your needs?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: meetscustmlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: meetscustmRadio,
                                    autofocus: false,
                                    title: Text(
                                        meetscustmlist[index].name.toString()),
                                    value: meetscustmlist[index],
                                    onChanged: (MeetsCustomerNeeds? value) {
                                      setState(() {
                                        meetscustmRadio = value;
                                        meetscustm = meetscustmlist[index].name;
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "How would you rate the quality of the product?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productquallist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: productqualRadio,
                                    autofocus: false,
                                    title: Text(
                                        productquallist[index].name.toString()),
                                    value: productquallist[index],
                                    onChanged: (ProductQualityModel? value) {
                                      setState(() {
                                        productqualRadio = value;
                                        productqual =
                                            productquallist[index].name;
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "How would you rate the value for money of the product?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productvaluelist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: productvalueRadio,
                                    autofocus: false,
                                    title: Text(productvaluelist[index]
                                        .name
                                        .toString()),
                                    value: productvaluelist[index],
                                    onChanged:
                                        (ProductValuabilityModel? value) {
                                      setState(() {
                                        productvalueRadio = value;
                                        productvalue =
                                            productvaluelist[index].name;
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "How responsive have we been to your questions or concerns about our products?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: customerservicelist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: customerserviceRadio,
                                    autofocus: false,
                                    title: Text(customerservicelist[index]
                                        .name
                                        .toString()),
                                    value: customerservicelist[index],
                                    onChanged: (CustomerServiceModel? value) {
                                      setState(() {
                                        customerserviceRadio = value;
                                        customerservice =
                                            customerservicelist[index].name;
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "How long have you been a user of our Product?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: usersincelist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: usersinceRadio,
                                    autofocus: false,
                                    title: Text(
                                        usersincelist[index].name.toString()),
                                    value: usersincelist[index],
                                    onChanged: (ProductUsageSinceModel? value) {
                                      setState(() {
                                        usersinceRadio = value;
                                        usersince = usersincelist[index].name;
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "How likely are you to purchase any of our other products?",
                              style: TextStyle(color: iconColor, fontSize: 18)),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: wantotherproductlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return RadioListTile(
                                    groupValue: wantotherproductRadio,
                                    autofocus: false,
                                    title: Text(wantotherproductlist[index]
                                        .name
                                        .toString()),
                                    value: wantotherproductlist[index],
                                    onChanged: (WantOtherProductsModel? value) {
                                      setState(() {
                                        wantotherproductRadio = value;
                                        wantotherproduct =
                                            wantotherproductlist[index].name;
                                      });
                                    },
                                  );
                                }),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Feedback',
                            style: TextStyle(color: iconColor, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'field can\'t be empty ';
                              }

                              return null;
                            }),
                            style: const TextStyle(fontSize: 17),
                            cursorHeight: 25,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            controller: feedbackcontroler,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 15, top: 10, bottom: 10),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Feedback',
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: const [
                              Text(
                                'Upload Image',
                                style:
                                    TextStyle(color: iconColor, fontSize: 18),
                              ),
                              Text(
                                " (Optional)",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 120,
                                width: 100,
                                child: IconButton(
                                  icon: const Icon(Icons.add_a_photo),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              actions: [
                                                const Center(
                                                  child: Text(
                                                    "Upload Picture",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Card(
                                                  color: primaryColor,
                                                  child: InkWell(
                                                    onTap: () {
                                                      pickimage();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: const [
                                                          Icon(
                                                            Icons.photo_album,
                                                            color: Colors.black,
                                                          ),
                                                          Text(
                                                            '  Pick From Gallery',
                                                            style: TextStyle(
                                                              color: iconColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  color: primaryColor,
                                                  child: InkWell(
                                                    onTap: () {
                                                      pickimageFromCamera();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: const [
                                                          Icon(
                                                            Icons.camera_alt,
                                                            color: Colors.black,
                                                          ),
                                                          Text(
                                                            '  Pick From Camera',
                                                            style: TextStyle(
                                                                color:
                                                                    iconColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)),
                                  color: Colors.white,
                                ),
                              ),
                              isShow
                                  ? Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        height: 120,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _fileimages.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        Image.file(
                                                          _fileimages[index],
                                                          fit: BoxFit.fill,
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          child: InkWell(
                                                            onTap: () {
                                                              _fileimages
                                                                  .removeAt(
                                                                      index);
                                                              setState(() {});
                                                            },
                                                            child: const Icon(
                                                              Icons.cancel,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              );
                                            }),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Signature',
                            style: TextStyle(color: iconColor, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignaturePage(
                                            callback: (byteimg, img64) {
                                      setState(() {
                                        imageBytes = byteimg;

                                        signatureimage = img64;
                                      });
                                    }),
                                  ));
                            },
                            child: Container(
                              color: Colors.white,
                              height: 150,
                              width: double.infinity,
                              child: imageBytes != null
                                  ? Image.memory(imageBytes!)
                                  : const Center(
                                      child: Text("Tap to add signature")),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: iconColor),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      setState(() {
                                        isloading = true;
                                      });
                                      createSurvey();
                                    } else {
                                      if (_selectedorganizationid == null) {
                                        setState(() {
                                          orgerror = true;
                                        });
                                      } else {
                                        setState(() {
                                          orgerror = false;
                                        });
                                      }
                                    }
                                  },
                                  child: const Text("Create Survey")))
                        ],
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: CircularProgressIndicator()))),
        ),
      ),
    );
  }
}
