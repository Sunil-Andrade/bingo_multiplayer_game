import 'package:bingo_app/models/room_model.dart';

Response parseResponse(Map<String, dynamic> json) {
  final flag = json['flag'];
  final payload = json['payload'];

  switch (flag) {
    case 1:
      return Response(
        flag: flag,
        payload: CreateGame(
          gameId: payload['gameid'],
          playerNum: payload['playernum'],
        ),
      );
    case 2:
      return Response(
        flag: 2,
        payload: PlayerJoined(
          names: List<String>.from(payload['players']),
          max: payload['max'],
        ),
      );
    case -1:
      return Response(
        flag: flag,
        payload: GameError(message: payload['res']),
      );
    case 3:
      return Response(flag: flag, payload: GameStartedModel());
    case 4:
      return Response(
        flag: flag,
        payload: RemTime(time: payload['remtime']),
      );
    case 5:
      return Response(flag: flag, payload: StartGame());
    case 10:
      return Response(
        flag: flag,
        payload: WhosTurn(
          name: payload['name'],
          marked: payload['marked'],
          toWin: payload["score"],
        ),
      );
    case 66:
      return Response(
        flag: 66,
        payload: Winners(names: List<String>.from(payload['winners'])),
      );

    default:
      throw Exception('Unknown response flag: $flag');
  }
}
