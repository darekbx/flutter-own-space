
class Image {

  final String url;

  Image(this.url);

  Image.fromJson(Map<String, dynamic> json)
      : url = json['url'];
}