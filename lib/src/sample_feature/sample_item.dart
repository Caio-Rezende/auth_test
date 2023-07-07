/// A placeholder class that represents an entity or model.
class SampleItem {
  const SampleItem(this.id);

  final int id;

  SampleItem.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {'id': id};
}
