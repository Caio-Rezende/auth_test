import 'package:auth_test/src/contact/contact_item.dart';
import 'package:auth_test/src/contact/contact_send_message_dialog.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class ContactItemView extends StatefulWidget {
  static const String routeName = '/contact_item';

  final ContactItem item;
  const ContactItemView({super.key, required this.item});

  @override
  State<StatefulWidget> createState() => _ContactItemViewState();
}

class _ContactItemViewState extends State<ContactItemView> {
  bool saving = false;
  bool editing = false;
  String? name;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      name = widget.item.name;
      editing = name == null;
      if (!editing) {
        _controller.text = name!;
      }
    });
  }

  void saveContact(String value) async {
    setState(() {
      saving = true;
    });

    widget.item.name = value;
    await widget.item.toStorage();

    setState(
      () {
        saving = false;
        name = value;
      },
    );
  }

  sendMessage() {
    showDialog(
        context: context,
        builder: (context) => ContactSendMessageDialog(item: widget.item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact ${widget.item.name}'),
      ),
      body: Center(
        child: !editing
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name!),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => setState(() => editing = true),
                        child: const Text('Edit'),
                      ),
                      const SizedBox.square(
                        dimension: 20,
                      ),
                      OutlinedButton(
                        onPressed: sendMessage,
                        child: const Text('Send Message'),
                      ),
                    ],
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
                      decoration: const InputDecoration(
                          labelText: 'Give the contact a name'),
                      maxLines: 1,
                      autofocus: true,
                      onChanged: saveContact,
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
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  Text(widget.item.publicKey)
                ],
              ),
      ),
    );
  }
}
