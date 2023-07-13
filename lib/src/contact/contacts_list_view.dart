import 'dart:convert';

import 'package:auth_test/src/contact/contact_item.dart';
import 'package:auth_test/src/contact/contact_item_view.dart';
import 'package:auth_test/src/contact/contact_scan_view.dart';
import 'package:auth_test/src/secret/secure_storage_controller.dart';
import 'package:flutter/material.dart';

class ContactsListView extends StatefulWidget {
  /// Default Constructor
  const ContactsListView({super.key});

  @override
  State<ContactsListView> createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  final SecureStorageController _secureStorage = SecureStorageController();

  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  _loadItems() {
    _secureStorage.get(ContactItem.listKey).then((value) {
      if (value != null) {
        final List<dynamic> parsed = jsonDecode(value);
        setState(() {
          items = parsed.map((e) => e.toString()).toList();
        });
      }
    });
  }

  startScan() async {
    await Navigator.pushNamed(context, ContactScanView.routeName);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
          restorationId: 'contactsListView',
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];

            return FutureBuilder<ContactItem?>(
              future: ContactItem.fromStorage(item),
              builder: (ctx, snap) => snap.error != null
                  ? Text('Error loading $item')
                  : !snap.hasData || snap.data == null
                      ? Text('Not Found $item')
                      : ListTile(
                          title: Text(snap.data!.name),
                          leading: const Icon(Icons.people),
                          onTap: () async {
                            // Navigate to the details page. If the user leaves and returns to
                            // the app after it has been killed while running in the
                            // background, the navigation stack is restored.
                            await Navigator.pushNamed(
                              context,
                              ContactItemView.routeName,
                              arguments: jsonEncode(snap.data!),
                            );

                            _loadItems();
                          }),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
