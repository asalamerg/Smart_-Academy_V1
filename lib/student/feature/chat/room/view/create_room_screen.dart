
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_academy/shared/error/show_error.dart';
import 'package:smart_academy/shared/loading/loading_indicator.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';
import 'package:smart_academy/student/feature/chat/chat_screen_home.dart';
import 'package:smart_academy/student/feature/chat/room/model/room_model.dart';
import 'package:smart_academy/student/feature/chat/room/view_model/status_room.dart';
import 'package:smart_academy/student/feature/chat/room/view_model/view_model_room.dart';



class CreateRoomScreen extends StatefulWidget{
  static const routeName="create_room_screen";

  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController roomName = TextEditingController();
  TextEditingController roomDescription = TextEditingController();
  final viewModel=ViewModelRoom() ;


  @override

  @override
  Widget build(BuildContext context) {



    return Form(
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/background.png"),
              fit: BoxFit.fill),
        ),
        child: BlocProvider(
          create: (context)=>viewModel,
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
                        .width * 0.40,
                    fit: BoxFit.fill,
                  ),
                  DefaultTextFormField(title: "Enter Courses Name ",
                    controller: roomName,
                    validator: validation.name,),
                  DefaultTextFormField(title: "Enter Description Courses",
                    controller: roomDescription,
                    validator: validation.description,),


                  BlocListener<ViewModelRoom,StatusRoom>
                    ( listener :(_,status){
                      if(status is CreateRoomLoading){ const LoadingIndicator();}
                      else if(status is CreateRoomSuccess){
                        Navigator.of(context).pushReplacementNamed(Chat.routeName);
                        ToastHelper.showSuccess("The operation was successful. ");


                      }
                      else if(status is CreateRoomError){

                        ToastHelper.showError(" Something went wrong");
                      }


                  },child : DefaultButton(title: "Create ", onPressed: createRoom,)),
                ],),
              ),
            ),
          ),
        ),
      ),
    );

  }
  void createRoom() {
    if (formKey.currentState!.validate()) {

      BlocProvider.of<ViewModelRoom>(context).createRoomViewModel(
          RoomModel(description:roomDescription.text , name: roomName.text));
      Navigator.of(context).pop();

    }

  }
}