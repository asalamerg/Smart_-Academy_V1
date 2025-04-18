
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatelessWidget{
  static const routeName="create_room_screen";
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(),
    body: Center(child: Text("create"),),
  );
  }
}