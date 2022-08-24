import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import 'package:nctserviceapp/model/surveymodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'create_survey.dart';
import 'surveydetail.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  bool isloading = false;
  List<SurveyModel> surveylist = [];
  Future<List<SurveyModel>?> getDatafromApi(value) async {
    try {
      setState(() {
        isloading = true;
      });
      var url = "https://support.nctbutwal.com.np/api/surveys/all";
      List<SurveyModel> detail = [];
      final prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body)["data"];

      for (var u in data) {
        detail.add(SurveyModel.fromJson(u));
      }
      if (mounted) {
        setState(() {
          surveylist = detail;

          isloading = false;
        });
      }

      return detail;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatafromApi(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Center(child: Text("Survey List")),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreateSurveyPage();
              })).then((value) {
                if (value) {
                  getDatafromApi(value);
                }
              });
            },
            child: Row(
              children: const [
                Icon(
                  Icons.add,
                  size: 20,
                ),
                Text(
                  " Survey Now",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          getDatafromApi(true);
        },
        child: isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: surveylist.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (() {
                      Navigator.push(context, MaterialPageRoute(
                        builder: ((context) {
                          return SurveyDetail(
                            surveylist: surveylist[index],
                          );
                        }),
                      ));
                    }),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    surveylist[index].surveyDay.toString(),
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    surveylist[index]
                                        .surveyMonthYear
                                        .toString(),
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surveylist[index]
                                        .organizationName
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    surveylist[index]
                                        .representativeName
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    surveylist[index].surveyBy.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    surveylist[index].surveyAt.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
