import 'package:auth_test/src/secret/secure_storage_controller.dart';

/// A placeholder class that represents an entity or model.
class SampleItem {
  final String prefix = 'item';
  final int id;

  const SampleItem(this.id);

  Future<String?> get secret async =>
      await SecureStorageController().get('$prefix.$id');

  Future<void> setSecret(String value) async =>
      await SecureStorageController().save('$prefix.$id', value);

  SampleItem.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {'id': id};
}
