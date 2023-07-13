import 'dart:convert';
import 'dart:io';

import 'package:auth_test/src/contact/contact_item.dart';
import 'package:auth_test/src/secret/secure_storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ContactScanView extends StatefulWidget {
  static const routeName = '/contact_scan';
  const ContactScanView({super.key});

  @override
  State<StatefulWidget> createState() => _ContactScanViewState();
}

class _ContactScanViewState extends State<ContactScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR.contact');
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.white, borderWidth: 3),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a contact\'s public key'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final storage = SecureStorageController();
      final obj = await storage.get(ContactItem.listKey);
      List<String> list = [];
      if (obj != null) {
        final List<dynamic> parsed = jsonDecode(obj);
        list = parsed.map((e) => e.toString()).toList();
      }

      final item = ContactItem(publicKey: scanData.code!, name: 'New Contact');
      if (list.contains(item.hash)) {
        final saved = await ContactItem.fromStorage(item.hash);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact already saved as ${saved!.name}')));

        Navigator.pop(context);
        return;
      }

      item.toStorage();

      list.add(item.hash);
      storage.save(ContactItem.listKey, jsonEncode(list));

      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
