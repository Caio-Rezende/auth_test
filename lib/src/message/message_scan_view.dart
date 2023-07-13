import 'dart:io';

import 'package:auth_test/src/secret/share_controller.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MessageScanView extends StatefulWidget {
  static const routeName = '/message_scan';
  const MessageScanView({super.key});

  @override
  State<StatefulWidget> createState() => _MessageScanViewState();
}

class _MessageScanViewState extends State<MessageScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR.message');
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
              child: Text('Scan a message'),
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

      final msg = await ShareController().receiveMessage(scanData.code!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
