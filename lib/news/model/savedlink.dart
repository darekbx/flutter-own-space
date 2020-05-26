
class SavedLink {
  
  int id;
  int linkId;
  String title;
  String description;
  String imageUrl;

  SavedLink(this.id, this.linkId, this.title, this.description, this.imageUrl);

  factory SavedLink.fromMap(Map<String, dynamic> row) =>
      SavedLink(row["id"], row["linkId"], row["title"], row["description"], row["imageUrl"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "linkId": linkId,
        "title": title,
        "description": description,
        "imageUrl": imageUrl
      };
}