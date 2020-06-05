
class Category {
  final String id;
  final String name;
  final bool leaf;

  Category(this.id, this.name, this.leaf);

  Category.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      leaf = json['leaf'];
}