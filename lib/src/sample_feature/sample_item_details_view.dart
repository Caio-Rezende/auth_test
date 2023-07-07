import 'package:auth_test/src/auth/auth_controller.dart';
import 'package:auth_test/src/sample_feature/sample_item.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatefulWidget {
  static const routeName = '/sample_item';

  final SampleItem item;
  const SampleItemDetailsView({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _SampleItemDetaisViewState();
}

class _SampleItemDetaisViewState extends State<SampleItemDetailsView> {
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
  }

  tryAuth() {
    AuthController()
        .requestAuth()
        .then((authResult) => authenticated = authResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details ${widget.item.id}'),
      ),
      body: Center(
        child: authenticated
            ? const Text('More Information Here')
            : OutlinedButton(
                onPressed: tryAuth,
                child: const Text('Authenticate prior to seing the info'),
              ),
      ),
    );
  }
}
