import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

class SignaturePage extends StatefulWidget {
  final Function(Uint8List, String) callback;
  const SignaturePage({Key? key, required this.callback}) : super(key: key);

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  String? image64;
  Uint8List? imagebytes;
  final GlobalKey<SfSignaturePadState> _signaturePadStateKey = GlobalKey();
  pickSignature() async {
    ui.Image image = await _signaturePadStateKey.currentState!.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List imageBytes = byteData!.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    imagebytes = imageBytes;

    image64 = base64Encode(imageBytes);
    widget.callback(imagebytes!, image64.toString());
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SfSignaturePad(
                key: _signaturePadStateKey,
                backgroundColor: Colors.white,
                minimumStrokeWidth: 3.0,
                maximumStrokeWidth: 4.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                  ),
                  onPressed: () async {
                    _signaturePadStateKey.currentState!.clear();
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.check,
                    size: 30,
                  ),
                  onPressed: () {
                    pickSignature();

                    Navigator.pop(context);
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
