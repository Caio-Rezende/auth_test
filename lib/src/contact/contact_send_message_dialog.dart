import 'package:auth_test/src/message/message_send_qr_view.dart';
import 'package:auth_test/src/contact/contact_item.dart';
import 'package:auth_test/src/secret/share_controller.dart';

import 'package:flutter/material.dart';

class ContactSendMessageDialog extends AlertDialog {
  final ContactItem item;

  const ContactSendMessageDialog({super.key, required this.item})
      : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        );

  @override
  Widget? get content => _ContactSendMessageContent(item: item);
}

class _ContactSendMessageContent extends StatefulWidget {
  final ContactItem item;

  const _ContactSendMessageContent({required this.item});

  @override
  State<StatefulWidget> createState() => _ContactState();
}

class _ContactState extends State<_ContactSendMessageContent> {
  String? msg;

  final TextEditingController _controller = TextEditingController();

  sendMessage() {
    if (_controller.text.isEmpty) {
      return;
    }

    final msg =
        ShareController().sendMessage(_controller.text, widget.item.publicKey);

    Navigator.popAndPushNamed(
      context,
      SendQRView.routeName,
      arguments: SendQRViewArguments(
          msg: msg, title: 'Message to ${widget.item.name}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Write the message'),
          maxLines: 1,
          autofocus: true,
        ),
        const SizedBox.square(
          dimension: 20,
        ),
        OutlinedButton(
          onPressed: sendMessage,
          child: const Text('Send Message'),
        )
      ],
    );
  }
}
