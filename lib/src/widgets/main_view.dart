import 'package:auth_test/src/contact/contacts_list_view.dart';
import 'package:auth_test/src/message/message_scan_view.dart';
import 'package:auth_test/src/sample_feature/sample_item_list_view.dart';
import 'package:auth_test/src/secret/share_controller.dart';
import 'package:auth_test/src/settings/settings_view.dart';
import 'package:flutter/material.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class MainView extends StatefulWidget {
  const MainView({super.key});

  static const routeName = '/main';

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();

    test();
  }

  test() async {
    final share = ShareController();
    final encoded = share.sendMessage(
        'your keys are configured', await share.getPublicKey());
    final decoded = await share.receiveMessage(encoded);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(decoded)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secrets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, MessageScanView.routeName);
            },
          ),
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
      body: const DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Colors.blueAccent,
            tabs: [
              Tab(
                text: 'Items',
              ),
              Tab(
                text: 'People',
              ),
            ],
          ),
          body: TabBarView(
            children: [
              SampleItemListView(),
              ContactsListView(),
            ],
          ),
        ),
      ),
    );
  }
}
