import 'package:auth_test/src/secret/secret_controller.dart';

/// A placeholder class that represents an entity or model.
class SampleItem {
  const SampleItem(this.id);

  final int id;

  Future<String?> get secret async =>
      await SecretController().get('sample.$id');

  Future<void> setSecret(String value) async =>
      await SecretController().save('sample.$id', value);

  SampleItem.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {'id': id};
}
