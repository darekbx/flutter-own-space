
class Parameter {

  final String name;
  final List<String> values;

  Parameter(this.name, this.values);

  Parameter.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        values = (json['values'] as List)
            .map((item) => item.toString())
            .toList();
}