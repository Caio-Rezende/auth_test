import 'package:auth_test/src/sample_feature/sample_item.dart';
import 'package:auth_test/src/sample_feature/sample_item_list_view.dart';
import 'package:auth_test/src/sample_feature/sample_item_secret_view.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatefulWidget {
  static const routeName = '/sample_item';

  final SampleItem item;
  const SampleItemDetailsView({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _SampleItemDetaisViewState();
}

class _SampleItemDetaisViewState extends State<SampleItemDetailsView>
    with WidgetsBindingObserver {
  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Add the observer.
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Navigator.popAndPushNamed(context, SampleItemListView.routeName);

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details ${widget.item.id}'),
      ),
      body: Center(
        child: SampleItemSecretView(item: widget.item),
      ),
    );
  }
}
