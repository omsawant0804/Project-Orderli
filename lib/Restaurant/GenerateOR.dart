import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QRCodeGeneratorScreen extends StatefulWidget {
  const QRCodeGeneratorScreen({super.key});
  @override
  State<QRCodeGeneratorScreen> createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  String restoId="";
  final user = FirebaseAuth.instance.currentUser;
  String url = "v://app/restaurant-menu?id=";

  String generateQRCode(String url) {
    // Replace this with your custom QR code generation logic
    return "https://api.qrserver.com/v1/create-qr-code/?data=$url&size=200x200";
  }

  Future<Uint8List> _generateQRCodeImage(String url) async {
    final qrValidationResult = QrValidator.validate(
      data: url,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode!;
      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFF000000),
        gapless: true,
      );
      final picData = await painter.toImageData(200);
      return picData!.buffer.asUint8List();
    } else {
      throw Exception('QR code generation failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restoId=user!.uid.toString();
    url = "v://app/restaurant-menu?id=$restoId";
    print(restoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:EdgeInsetsDirectional.fromSTEB(8.0,0, 8.0, 0),
              child: Container(
                width: 400,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFFE86A42),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                // color: Color(0xFFE86A42),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Generate QR Code",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 150,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(generateQRCode(url)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Uint8List qrImageData = await _generateQRCodeImage(url);
                    final result = await ImageGallerySaver.saveImage(qrImageData);
                    if (result['isSuccess']) {
                      print("hello");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('QR code saved to gallery')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save QR code')),
                      );
                    }
                  },
                  child: Text('Save QR Code'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}