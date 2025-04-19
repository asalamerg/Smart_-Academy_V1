
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/authentication/presentation/widget/default_button.dart';
import 'package:smart_academy/feature/authentication/presentation/widget/textformfield.dart';
import 'package:smart_academy/feature/authentication/presentation/widget/validation.dart';

class CreateRoomScreen extends StatefulWidget{
  static const routeName="create_room_screen";

  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController roomName = TextEditingController();
    TextEditingController roomDescription = TextEditingController();



    return Form(
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/background.png"),
              fit: BoxFit.fill),
        ),
        child: Scaffold(

          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text("Create Room ",style: Theme.of(context).textTheme.displayLarge),

          foregroundColor: Colors.white,),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.15),
              child: Column(children: [
                Image(image: const AssetImage("assets/image/room.png")
                  , height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.15,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.15,
                  fit: BoxFit.fill,
                ),
                DefaultTextFormField(title: "Enter Room Name ",
                  controller: roomName,
                  validator: validation.name,),
                DefaultTextFormField(title: "Enter Room Description",
                  controller: roomDescription,
                  validator: validation.name,),
                DefaultButton(title: "Create ", onPressed: createRoom,),
              ],),
            ),
          ),
        ),
      ),
    );

  }
  void createRoom() {
    if (formKey.currentState!.validate()) {

    }

  }
}