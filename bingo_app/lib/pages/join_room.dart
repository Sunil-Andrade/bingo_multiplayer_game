import 'package:bingo_app/bloc/bingo_bloc.dart'
    show
        BingoBloc,
        BingoErrorState,
        BingoState,
        CreateRoomE,
        GameCreated,
        JoinRoomE,
        PlayerJoinedState;
import 'package:bingo_app/models/room_model.dart';
import 'package:bingo_app/pages/make_room.dart';
import 'package:bingo_app/pages/waitin_page.dart' show WaitinPage;
import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String code = "00000";

  @override
  Widget build(BuildContext context) {
    return BlocListener<BingoBloc, BingoState>(
      listener: (context, state) {
        if (state is PlayerJoinedState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WaitinPage(
                code: int.parse(code),
                playerNum: 0,
                isPlayerHost: false,
              ),
            ),
          );
        }
        if (state is BingoErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 400,
            height: 340,

            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: AppInputStyles.decoration().copyWith(
                          hint: Text(
                            "Enter name",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a valid name'; // Returns error text
                          }
                          return null; // Input is valid
                        },
                        onSaved: (value) {
                          name = value ?? "";
                        },
                      ),

                      SizedBox(height: 20),
                      TextFormField(
                        decoration: AppInputStyles.decoration().copyWith(
                          hint: Text(
                            "Enter room code",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter the code'; // Returns error text
                          }
                          return null; // Input is valid
                        },
                        onSaved: (value) {
                          code = value ?? "";
                        },
                      ),

                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context.read<BingoBloc>().add(
                                JoinRoomE(roomId: int.parse(code), name: name),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coral,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),

                            shape: const StadiumBorder(),
                            textStyle: AppTextStyles.button,
                          ),
                          child: Text("Join Room"),
                        ),
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (builder) => MakeRoom()),
                    );
                  },
                  child: Text("Create a room"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
