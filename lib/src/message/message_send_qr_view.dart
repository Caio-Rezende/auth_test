import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SendQRView extends StatelessWidget {
  static const String routeName = 'qr';

  final String title;
  final String msg;

  const SendQRView({super.key, required this.msg, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: QrImageView(
        data: msg,
        version: QrVersions.auto,
        size: MediaQuery.of(context).size.width,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class SendQRViewArguments {
  final String title;
  final String msg;

  const SendQRViewArguments({required this.msg, required this.title});
}
