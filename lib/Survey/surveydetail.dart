import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nctserviceapp/component/constantcolor.dart';

import '../model/surveymodel.dart';

class SurveyDetail extends StatefulWidget {
  SurveyModel surveylist;
  SurveyDetail({Key? key, required this.surveylist}) : super(key: key);

  @override
  State<SurveyDetail> createState() => _SurveyDetailState();
}

class _SurveyDetailState extends State<SurveyDetail> {
  @override
  List<Marker> markers = <Marker>[];

  void marker() {
    double latitude = double.parse(widget.surveylist.latitude!);
    double longitude = double.parse(widget.surveylist.longitude!);

    Marker marker = Marker(
      markerId: const MarkerId("121"),
      position: LatLng(latitude, longitude),
      // icon: BitmapDescriptor.,
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: iconColor, title: const Text("Survey Detail")),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 8),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Organization :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.surveylist.organizationName.toString(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Survey By :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.surveyBy.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Representative Name :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.representativeName.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Feedback :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Survey Date :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.surveyDate.toString()),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Survey Time :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.surveyTime.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Survey Images :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(2)),
              height: 300,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.surveylist.images!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: SizedBox(
                              child: Image.network(
                                  widget.surveylist.images![index]),
                            ),
                            actions: <Widget>[
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Icon(Icons.cancel))
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 300,
                          child: Image.network(widget.surveylist.images![index],
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Survey Feedback :",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'How likely is it that you would recommend this company to a friendor colleague?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.surveylist.feedback!.companyRecommendation.toString() +
                  " Star",
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Overall, how satisfied or dissatisfied are you with our company?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.companySatisfaction.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Which of the following words would you use to describe our products?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    widget.surveylist.feedback!.productDescription!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                        widget.surveylist.feedback!.productDescription![index]),
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'How well do our products meet your needs?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.meetsCustomerNeeds.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'How would you rate the quality of the product?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.productQuality.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'How would you rate the value for money of the product?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.productValuability.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'How responsive have we been to your questions or concerns aboutour products?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.customerService.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'How long have you been a user of our Product?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.productUsageSince.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'How likely are you to purchase any of our other products?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.surveylist.feedback!.wantOtherProducts.toString()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Signature :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: SizedBox(
                height: 200,
                child:
                    Image.network(widget.surveylist.signatureImage.toString(),
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
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Survey Location :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: markers.toSet(),
                mapType: MapType.normal,
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.surveylist.latitude!),
                      double.parse(widget.surveylist.longitude!)),
                  zoom: 15.68,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
