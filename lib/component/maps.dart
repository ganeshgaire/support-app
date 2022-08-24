import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrganizationMap extends StatefulWidget {
  final Function(String, String) callback;
  const OrganizationMap({Key? key, required this.callback}) : super(key: key);

  @override
  State<OrganizationMap> createState() => _OrganizationMapState();
}

class _OrganizationMapState extends State<OrganizationMap> {
  String? lattitude;
  String? longitude;
  final Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onTap: (pos) {
              print(pos.latitude);
              setState(() {
                lattitude = pos.latitude.toString();
                longitude = pos.longitude.toString();
                widget.callback(lattitude!, longitude!);
                _markers.clear();
                _markers.add(Marker(
                  markerId: const MarkerId("id-1"),
                  position: pos,
                ));
                print(_markers);
              });
            },
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(27.686386, 83.432426),
              zoom: 15,
            ),
          ),
        ),
      ],
    );
  }
}
