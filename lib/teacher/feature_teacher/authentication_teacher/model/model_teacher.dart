
class ModelTeacher {
  String id;
  String name;

  String email;

  String numberId;



  ModelTeacher(
      {required this.name, required this.email, required this.numberId  ,required this.id});


  Map<String ,dynamic> toJson()=>{
    "id" : id ,
    "name"  : name ,
    "email" : email ,
    "numberId" :numberId ,

  };

  ModelTeacher.fromJson(Map<String ,dynamic> json ) : this(
    id: json['id'],
    name: json["name"],
    email: json["email"],
    numberId: json["numberId"],



  );
}