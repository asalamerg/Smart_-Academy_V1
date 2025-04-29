
class ModelAdmin {
  String id;
  String name;
  String email;



  ModelAdmin(
      {required this.name, required this.email ,required this.id});


  Map<String ,dynamic> toJson()=>{
    "id" : id ,
    "name"  : name ,
    "email" : email ,


  };

  ModelAdmin.fromJson(Map<String ,dynamic> json ) : this(
    id: json['id'],
    name: json["name"],
    email: json["email"],




  );
}