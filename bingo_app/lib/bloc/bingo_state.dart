part of 'bingo_bloc.dart';

@immutable
sealed class BingoState {}

final class BingoInitial extends BingoState {}

final class GameCreated extends BingoState {
  final CreateGame createGame;
  GameCreated({required this.createGame});
}

final class PlayerJoinedState extends BingoState {
  final List<String> playerNames;
  final int max;

  PlayerJoinedState({required this.max, required this.playerNames});
}

final class GameStarted extends BingoState {}

final class RemTimeS extends BingoState {
  final int remTime;

  RemTimeS({required this.remTime});
}

final class ConnectionClosed extends BingoState {}

final class StartGameState extends BingoState {}

final class BingoErrorState extends BingoState {
  final String message;

  BingoErrorState({required this.message});
}

class WhosTurnS extends BingoState {
  final String name;
  final int marked;
  final int toWin;

  WhosTurnS({required this.name, required this.marked, required this.toWin});
}

final class WinnersState extends BingoState {
  final List<String> playerNames;

  WinnersState({required this.playerNames});
}
