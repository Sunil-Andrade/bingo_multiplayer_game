// room model to craete the game
class RoomModel {
  final String playerName;
  final int plaerCount;
  const RoomModel({required this.plaerCount, required this.playerName});

  static Map<String, dynamic> toJson(RoomModel model) {
    return {
      "flag": 1,
      "payload": {"name": model.playerName, "playercount": model.plaerCount},
    };
  }
}

abstract class ResponseType {}

class CreateGame extends ResponseType {
  final int gameId;
  final int playerNum;
  CreateGame({required this.gameId, required this.playerNum});
}

class PlayerJoined extends ResponseType {
  final List<String> names;
  final int max;

  PlayerJoined({required this.names, required this.max});
}

class GameError extends ResponseType {
  final String message;

  GameError({required this.message});
}

//game started
class GameStartedModel extends ResponseType {}

//timer
class RemTime extends ResponseType {
  final int time;

  RemTime({required this.time});
}

//end timer start the game
class StartGame extends ResponseType {}

//submit bingomatrix
class BingoMatrix {
  final List<int> matrix;
  const BingoMatrix({required this.matrix});

  static Map<String, dynamic> toJson(BingoMatrix model) {
    return {
      "flag": 12,
      "payload": {"matrix": model.matrix},
    };
  }
}

class WhosTurn extends ResponseType {
  final String name;
  final int marked;
  final int toWin;

  WhosTurn({required this.name, required this.marked,required this.toWin});
}

//action made

// class ActionMade extends ResponseType {
//   final int index;

//   ActionMade({required this.index});

//    static Map<String, dynamic> toJson(ActionMade model) {
//     return {
//       "flag": 12,
//       "payload": {"matrix": model.matrix},
//     };
//   }

// }

class Winners extends ResponseType {
  final List<String> names;
  Winners({required this.names});
}

class Response {
  int flag;
  ResponseType payload;
  Response({required this.flag, required this.payload});
}
