
class ModelUser {
  String id;
  String name;

  String email;

  String numberId;



  ModelUser(
      {required this.name, required this.email, required this.numberId  ,required this.id});


  Map<String ,dynamic> toJson()=>{
    "id" : id ,
    "name"  : name ,
    "email" : email ,
    "numberId" :numberId ,

  };

  ModelUser.fromJson(Map<String ,dynamic> json ) : this(
    id: json['id'],
    name: json["name"],
    email: json["email"],
    numberId: json["numberId"],



  );
}