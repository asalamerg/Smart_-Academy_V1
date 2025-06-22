import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/chat/room/model/room_model.dart';
import 'package:smart_academy/chat/room/view_model/status_room.dart';
import 'package:smart_academy/chat/room/view_model/view_model_room.dart';
import 'package:smart_academy/shared/error/error.dart';
import 'package:smart_academy/shared/error/show_error.dart' show ToastHelper;
import 'package:smart_academy/shared/loading/loading.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';

class CreateRoomScreen extends StatefulWidget {
  static const String routeName = "CreateRoomScreen";

  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  TextEditingController roomName = TextEditingController();
  TextEditingController roomDescription = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final viewModelRoom = RoomViewModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModelRoom,
      child: Form(
          key: formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
                //  Image.asset("assets/image/room.png" ,
                //    height: MediaQuery.of(context).size.height * 0.30 ,
                //    width: MediaQuery.of(context).size.width * 0.60 ,fit: BoxFit.fill,),

                DefaultTextFormField(
                  title: "Enter Room Name ",
                  controller: roomName,
                  validator: validation.name,
                ),

                DefaultTextFormField(
                  title: "Enter Room Description ",
                  controller: roomDescription,
                  validator: validation.description,
                ),

                const SizedBox(
                  height: 20,
                ),

                BlocListener<RoomViewModel, StatusRoom>(
                  listener: (context, state) {
                    if (state is CreateRoomLoading) {
                      const Loading();
                    } else if (state is CreateRoomSuccess) {
                      const Loading();
                      ToastHelper.showSuccess("Create Room Success  ");
                      Navigator.of(context).pop();
                    } else if (state is CreateRoomError) {
                      const Loading();
                      ErrorIndicator(
                        message: state.message,
                      );
                    }
                  },
                  child: DefaultButton(
                    title: " Create  ",
                    onPressed: createRoom,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void createRoom() {
    if (formKey.currentState!.validate()) {
      viewModelRoom.createRoomFrom(
          RoomModel(name: roomName.text, description: roomDescription.text));
    }
  }
}
