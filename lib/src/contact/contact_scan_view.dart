import 'dart:convert';
import 'dart:io';

import 'package:auth_test/src/contact/contact_item.dart';
import 'package:auth_test/src/secret/secure_storage_controller.dart';
import 'package:auth_test/src/widgets/main_view.dart';
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
            flex: 4,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.white, borderWidth: 3),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Scan a contact\'s public key'),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(labelText: 'or Paste here'),
                          maxLines: 1,
                          autofocus: false,
                          onSubmitted: (value) => action(value),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code == null) return;

      action(scanData.code!);
    });
  }

  action(String code) async {
    final storage = SecureStorageController();
    final obj = await storage.get(ContactItem.listKey);
    List<String> list = [];
    if (obj != null) {
      final List<dynamic> parsed = jsonDecode(obj);
      list = parsed.map((e) => e.toString()).toList();
    }

    final item = ContactItem(publicKey: code, name: 'New Contact');
    if (list.contains(item.hash)) {
      final saved = await ContactItem.fromStorage(item.hash);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact already saved as ${saved!.name}')));

      Navigator.popAndPushNamed(context, MainView.routeName);
      return;
    }

    item.toStorage();

    list.add(item.hash);
    storage.save(ContactItem.listKey, jsonEncode(list));

    Navigator.popAndPushNamed(context, MainView.routeName);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
