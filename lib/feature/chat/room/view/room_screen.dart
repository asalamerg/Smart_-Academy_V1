
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/feature/chat/room/view_model/status_room.dart';
import 'package:smart_academy/feature/chat/room/view_model/view_model_room.dart';
import 'package:smart_academy/shared/error/error.dart';
import 'package:smart_academy/shared/loading/loading.dart';
import 'room_item.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late ViewModelRoom viewModel;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      viewModel = BlocProvider.of<ViewModelRoom>(context);
      viewModel.getRoomViewModel();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocConsumer<ViewModelRoom, StatusRoom>(
            listener: (context, state) {
              if (state is DeleteRoomSuccess) {
                setState(() {}); // تحديث الواجهة
              }
              if (state is DeleteRoomError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ أثناء الحذف: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is GetRoomLoading || state is DeleteRoomLoading) {
                return const Loading();
              } else if (state is GetRoomError) {
                return ErrorIndicator(message: state.message);
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: viewModel.rooms.length,
                  itemBuilder: (context, index) =>
                      RoomItem(roomModel: viewModel.rooms[index]),
                );
              }
            },
          ),
        ),
      ),

    );
  }
}

