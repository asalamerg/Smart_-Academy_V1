// class ModelParent {
//   String id;
//   String name;
//
//   String email;
//
//   String numberId;
//
//
//
//   ModelParent(
//       {required this.name, required this.email, required this.numberId  ,required this.id});
//
//
//   Map<String ,dynamic> toJson()=>{
//     "id" : id ,
//     "name"  : name ,
//     "email" : email ,
//     "numberId" :numberId ,
//
//   };
//
//   ModelParent.fromJson(Map<String ,dynamic> json ) : this(
//     id: json['id'],
//     name: json["name"],
//     email: json["email"],
//     numberId: json["numberId"],
//
//
//
//   );
// }

class ModelParent {
  String id;
  String name;
  String email;
  String numberId;

  ModelParent({
    required this.id,
    required this.name,
    required this.email,
    required this.numberId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "numberId": numberId,
      };

  ModelParent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        numberId = json['numberId'];
}
