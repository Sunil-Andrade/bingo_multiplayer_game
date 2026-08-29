import 'package:bingo_app/bloc/bingo_bloc.dart';
import 'package:bingo_app/pages/make_room.dart';
import 'package:bingo_app/pages/winner_page.dart';
import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.numbers});

  final List<int> numbers;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Set<int> markedSet = {};
  int toWin = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<BingoBloc, BingoState>(
      listener: (context, state) {
        if (state is WinnersState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (builder) => WinnerPage(names: state.playerNames),
            ),
          );
        }
        if (state is ConnectionClosed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (builder) => MakeRoom()),
          );
        }
        if (state is WhosTurnS) {
          setState(() {
            markedSet.add(state.marked);
            toWin = state.toWin;
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: () {
                  context.read<BingoBloc>().add(CloseConnection());
                },
                child: Text("Exit"),
              ),
            ),

            //
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: BlocBuilder<BingoBloc, BingoState>(
                  builder: (context, state) {
                    if (state is RemTimeS) {
                      return Text(
                        "Timer ${state.remTime}",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.active,
                        ),
                      );
                    }
                    if (state is WhosTurnS) {
                      return Text(
                        "${state.name}'s Turn",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.active,
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),

            //
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  con("B", toWin >= 1),
                  con("I", toWin >= 2),
                  con("N", toWin >= 3),
                  con("G", toWin >= 4),
                  con("O", toWin >= 5),
                ],
              ),
            ),

            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: GridView.builder(
                  itemCount: 25,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<BingoBloc>().add(
                          ActionMade(number: widget.numbers[index]),
                        );
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: markedSet.contains(widget.numbers[index])
                              ? AppColors.active
                              : AppColors.mint,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (widget.numbers[index]).toString(),
                            style: AppTextStyles.title,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget con(String label, bool isTrue) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: isTrue
            ? const Color.fromARGB(255, 51, 194, 241)
            : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(
          color: isTrue ? AppColors.charcoal : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Center(child: Text(label, style: AppTextStyles.title)),
    );
  }
}
