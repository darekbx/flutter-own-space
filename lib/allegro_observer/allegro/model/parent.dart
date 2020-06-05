
class Parent {
  final String id;

  Parent(this.id);

  Parent.fromJson(Map<String, dynamic> json)
      : id = json['id'];
}