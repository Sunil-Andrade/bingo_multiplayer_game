import 'dart:ffi';

import 'package:bingo_app/bloc/bingo_bloc.dart';
import 'package:bingo_app/models/room_model.dart';
import 'package:bingo_app/pages/join_room.dart';
import 'package:bingo_app/pages/waitin_page.dart';
import 'package:bingo_app/service/websocket_service.dart';
import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeRoom extends StatefulWidget {
  const MakeRoom({super.key});

  @override
  State<MakeRoom> createState() => _MakeRoomState();
}

class _MakeRoomState extends State<MakeRoom> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  int size = 2;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BingoBloc, BingoState>(
      listener: (context, state) {
        if (state is GameCreated) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WaitinPage(
                isPlayerHost: true,
                code: state.createGame.gameId,
                playerNum: state.createGame.playerNum,
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
                        initialValue: "Alice",
                        decoration: AppInputStyles.decoration(),
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonFormField<int>(
                          initialValue: 2,
                          decoration: const InputDecoration(
                            labelText: 'Players',
                            border: InputBorder.none,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 2,
                              child: Text('2 Players'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('3 Players'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text('4 Players'),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text('5 Players'),
                            ),
                          ],
                          onChanged: (value) {
                            size = value ?? 2;
                          },
                        ),
                      ),
                      SizedBox(height: 60),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context.read<BingoBloc>().add(
                                CreateRoomE(
                                  roomModel: RoomModel(
                                    plaerCount: size,
                                    playerName: name,
                                  ),
                                ),
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
                          child: Text("Create Room"),
                        ),
                      ),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (builder) => JoinRoom()),
                    );
                  },
                  child: Text("Join a room"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
