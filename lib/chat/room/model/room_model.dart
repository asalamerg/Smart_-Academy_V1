
class RoomModel {
  String id;
  String name;
  String description;

  RoomModel({ this.id="", required this.description, required this.name});

  RoomModel.fromJson(Map<String,dynamic> json) : this(
    id:  json["id"],
    name:  json["name"],
    description: json["description"]
  );



  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "description": description,
      };


}
