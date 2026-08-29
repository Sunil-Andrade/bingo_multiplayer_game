import 'package:bingo_app/bloc/bingo_bloc.dart';
import 'package:bingo_app/pages/play_game_page.dart';
import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitinPage extends StatefulWidget {
  const WaitinPage({
    super.key,
    required this.code,
    required this.playerNum,
    required this.isPlayerHost,
  });

  final int code;
  final int playerNum;
  final bool isPlayerHost;

  @override
  State<WaitinPage> createState() => _WaitinPageState();
}

class _WaitinPageState extends State<WaitinPage> {
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
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.mint,

                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Room Code",
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.coral,
                        ),
                      ),
                      Text(widget.code.toString(), style: AppTextStyles.number),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                BlocBuilder<BingoBloc, BingoState>(
                  builder: (context, state) {
                    if (state is PlayerJoinedState) {
                      return Column(
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
                                child: Text(
                                  "${state.playerNames.length}/${state.max}",
                                  style: AppTextStyles.label,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: state.playerNames.length,
                              itemBuilder: (builder, index) {
                                String playerName = state.playerNames[index];
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
                      );
                    }
                    return Text("Sorry");
                  },
                ),
                Spacer(),
                if (widget.isPlayerHost)
                  ElevatedButton(
                    onPressed: () {
                      context.read<BingoBloc>().add(StartGameE());
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
                    child: Text("Start Game"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
