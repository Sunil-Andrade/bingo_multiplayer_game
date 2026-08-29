part of 'bingo_bloc.dart';

@immutable
sealed class BingoEvent {}

class CreateRoomE extends BingoEvent {
  final RoomModel roomModel;

  CreateRoomE({required this.roomModel});
}

class ResponseReceivedE extends BingoEvent {
  final Response response;

  ResponseReceivedE(this.response);
}

class OnError extends BingoEvent {
  final String message;

  OnError({required this.message});
}

class StartGameE extends BingoEvent {}

class JoinRoomE extends BingoEvent {
  final int roomId;
  final String name;

  JoinRoomE({required this.roomId, required this.name});
}

class CloseConnection extends BingoEvent {}

class SubmitMatrix extends BingoEvent {
  final BingoMatrix matrix;

  SubmitMatrix({required this.matrix});
}

//action made
class ActionMade extends BingoEvent {
  final int number;

  ActionMade({required this.number});
}
