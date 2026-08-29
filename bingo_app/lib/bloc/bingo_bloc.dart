import 'dart:convert';

import 'package:bingo_app/models/room_model.dart';
import 'package:bingo_app/service/websocket_service.dart';
import 'package:bingo_app/utils/response_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bingo_event.dart';
part 'bingo_state.dart';

class BingoBloc extends Bloc<BingoEvent, BingoState> {
  WebsocketService websocketService;
  BingoBloc({required this.websocketService}) : super(BingoInitial()) {
    on<CreateRoomE>(createRoom);
    on<ResponseReceivedE>(responseReceived);
    on<JoinRoomE>(joinRoom);
    on<StartGameE>(startGame);
    on<SubmitMatrix>(submitMatrix);
    on<CloseConnection>(closeConnection);
    on<ActionMade>(submitAction);
    on<OnError>((event, emit) {
      emit(BingoErrorState(message: event.message));
    });
  }

  Future<void> createRoom(CreateRoomE event, Emitter emit) async {
    try {
      await websocketService.connect('creategame');
      listen();

      websocketService.send(RoomModel.toJson(event.roomModel));
    } catch (e) {
      emit(BingoErrorState(message: e.toString()));
    }
  }

  Future<void> joinRoom(JoinRoomE event, Emitter emit) async {
    try {
      await websocketService.join('joingame', event.roomId, event.name);
      listen();
    } catch (e) {
      emit(BingoErrorState(message: e.toString()));
    }
  }

  void startGame(StartGameE event, Emitter emit) {
    try {
      websocketService.send({"flag": 3});
    } catch (e) {
      emit(BingoErrorState(message: e.toString()));
    }
  }

  void listen() {
    websocketService.messages.listen(
      (message) {
        final response = parseResponse(jsonDecode(message));

        add(ResponseReceivedE(response));
      },
      onDone: () {
        print("It's done bro");
      },
      onError: (err) {
        print(err);
      },
    );
  }

  void closeConnection(CloseConnection event, Emitter emit) {
    try {
      websocketService.closeService();
      emit(ConnectionClosed());
    } catch (e) {
      emit(BingoErrorState(message: e.toString()));
    }
  }

  void submitMatrix(SubmitMatrix event, Emitter emit) {
    try {
      websocketService.send(BingoMatrix.toJson(event.matrix));
    } catch (e) {
      emit(BingoErrorState(message: e.toString()));
    }
  }

  void submitAction(ActionMade event, Emitter emit) {
    try {
      websocketService.send({
        "flag": 20,
        "payload": {"selected": event.number},
      });
    } catch (e) {
      emit(BingoErrorState(message: e.toString()));
    }
  }

  void responseReceived(ResponseReceivedE event, Emitter emit) {
    final response = event.response;

    switch (response.payload) {
      case CreateGame game:
        emit(GameCreated(createGame: game));

      case PlayerJoined playerJoined:
        emit(
          PlayerJoinedState(
            playerNames: playerJoined.names,
            max: playerJoined.max,
          ),
        );
      case GameStartedModel _:
        emit(GameStarted());
      case RemTime remTime:
        emit(RemTimeS(remTime: remTime.time));
      case StartGame _:
        emit(StartGameState());
      case WhosTurn w:
        emit(WhosTurnS(name: w.name, marked: w.marked, toWin: w.toWin));
      case Winners w:
        emit(WinnersState(playerNames: w.names));
    }
  }
}


//websocket has everything what its gonna return and everything 
//
