import 'package:auth_test/src/message/message_send_qr_view.dart';
import 'package:auth_test/src/secret/share_controller.dart';
import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _privateKey = '';
  final _share = ShareController();

  @override
  initState() {
    super.initState();

    _share.getPrivateKey().then(
          (value) => setState(() {
            _privateKey = value;
          }),
        );
  }

  _displayPublicKey() async {
    final publicKey = await _share.getPublicKey();
    Navigator.popAndPushNamed(
      context,
      SendQRView.routeName,
      arguments:
          SendQRViewArguments(msg: publicKey, title: 'Share your publicKey'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: Column(
            children: [
              DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: widget.controller.themeMode,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: widget.controller.updateThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              OutlinedButton(
                onPressed: _displayPublicKey,
                child: const Text('Share publicKey'),
              ),
              if (_privateKey.isNotEmpty) ...[
                const SizedBox.square(
                  dimension: 16,
                ),
                Text(_privateKey)
              ]
            ],
          ),
        ),
      ),
    );
  }
}
