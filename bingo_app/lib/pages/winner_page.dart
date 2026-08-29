import 'package:bingo_app/bloc/bingo_bloc.dart';
import 'package:bingo_app/pages/play_game_page.dart';
import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WinnerPage extends StatefulWidget {
  const WinnerPage({super.key, required this.names});
  final List<String> names;

  @override
  State<WinnerPage> createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<BingoBloc, BingoState>(
      listener: (context, state) {
        if (state is GameStarted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => PlayGamePage()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.all(20),
            width: 400,

            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text("Players"),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.mint,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: widget.names.length,
                        itemBuilder: (builder, index) {
                          String playerName = widget.names[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(playerName.substring(0, 1)),
                            ),
                            title: Text(
                              playerName,
                              style: AppTextStyles.title.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
