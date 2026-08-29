import 'package:bingo_app/bloc/bingo_bloc.dart';
import 'package:bingo_app/models/room_model.dart';
import 'package:bingo_app/pages/game_page.dart';
import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayGamePage extends StatefulWidget {
  const PlayGamePage({super.key});

  @override
  State<PlayGamePage> createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {
  List<int> numbers = List.filled(25, 0);
  List<bool> isMarked = List.filled(25, false);
  int lastMarked = -1;

  int count = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BingoBloc, BingoState>(
      listener: (context, state) {
        if (state is StartGameState) {
          context.read<BingoBloc>().add(
            SubmitMatrix(matrix: BingoMatrix(matrix: numbers)),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (builder) => GamePage(numbers: numbers)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
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
                    return CircularProgressIndicator();
                  },
                ),
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
                        if (lastMarked == index &&
                            isMarked[index] &&
                            numbers[index] != 0) {
                          numbers[index] = 0;
                          count--;
                          isMarked[index] = false;
                        } else if (!isMarked[index]) {
                          numbers[index] = count;
                          count++;
                          isMarked[index] = true;
                          lastMarked = index;
                        }
                        setState(() {});
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (numbers[index]).toString(),
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
}
