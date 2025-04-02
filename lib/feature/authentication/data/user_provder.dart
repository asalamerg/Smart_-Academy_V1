
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/authentication/data/model_user.dart';

class UserProvider with ChangeNotifier{
  ModelUser? modelUser ;

   void  UpdateUser(ModelUser? user){
    modelUser=user;
    notifyListeners();
  }
}