import 'package:auth_test/src/sample_feature/sample_item.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemSecretView extends StatefulWidget {
  final SampleItem item;
  const SampleItemSecretView({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _SampleItemSecretViewState();
}

class _SampleItemSecretViewState extends State<SampleItemSecretView> {
  bool hasLoaded = false;
  bool saving = false;
  bool editing = false;
  String? secret;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.item.secret.then((value) {
      setState(() {
        hasLoaded = true;
        secret = value;
        editing = value == null;
        if (!editing) {
          _controller.text = secret!;
        }
      });
    });
  }

  void saveSecret(String value) {
    setState(() {
      saving = true;
    });
    widget.item.setSecret(value).then(
          (ret) => setState(
            () {
              saving = false;
              secret = value;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? !editing
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(secret!),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() => editing = true),
                    child: const Text('Edit'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(labelText: 'Tell the secret'),
                      maxLines: 1,
                      autofocus: true,
                      onChanged: saveSecret,
                    ),
                  ),
                  if (saving) ...[
                    const SizedBox.square(
                      dimension: 20,
                    ),
                    const Text('Saving...'),
                  ],
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() => editing = false),
                    child: const Text('Done'),
                  ),
                ],
              )
        : const Text('Loading...');
  }
}
