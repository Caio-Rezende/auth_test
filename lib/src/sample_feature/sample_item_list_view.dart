import 'dart:convert';

import 'package:auth_test/src/secret/secret_controller.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  static const routeName = '/';

  const SampleItemListView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  bool loading = true;
  List<SampleItem> items = [];

  final SecretController _secretController = SecretController();

  @override
  void initState() {
    super.initState();

    _secretController.get('sample.count').then((value) => setState(
          () {
            loading = false;
            items.addAll(Iterable.generate(int.parse(value ?? "0"))
                .map((e) => SampleItem(e)));
          },
        ));
  }

  void addItem() {
    setState(() {
      items.add(SampleItem(items.length));
      _secretController.save('sample.count', items.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: loading
          ? const Text('Loading...')
          : ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'sampleItemListView',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                    title: Text('SecretItem ${item.id}'),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      // Navigate to the details page. If the user leaves and returns to
                      // the app after it has been killed while running in the
                      // background, the navigation stack is restored.
                      Navigator.restorablePushNamed(
                        context,
                        SampleItemDetailsView.routeName,
                        arguments: jsonEncode(item),
                      );
                    });
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        backgroundColor: Colors.green,
        child: const Icon(Icons.plus_one),
      ),
    );
  }
}
