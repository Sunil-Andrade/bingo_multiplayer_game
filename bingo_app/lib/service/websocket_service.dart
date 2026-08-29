import 'dart:convert';

import 'package:bingo_app/models/room_model.dart';
import 'package:bingo_app/utils/response_parser.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  WebsocketService();
  WebSocketChannel? channel;

  bool get isConnected => channel != null;

  final String baseUrl = 'ws://172.27.11.140:3000/ws';

  Future<void> connect(String endpoint) async {
    try {
      final newChannel = WebSocketChannel.connect(
        Uri.parse('ws://172.27.11.140:3000/$endpoint'),
      );

      await newChannel.ready;
      channel = newChannel;
    } catch (e) {
      channel = null;
      throw Exception("Could'nt Connect to Server");
    }
  }

  Future<void> join(String endpoint, int roomId, String name) async {
    print(endpoint);
    print(roomId);

    try {
      final newChannel = WebSocketChannel.connect(
        Uri(
          scheme: 'ws',
          host: '172.27.11.140',
          port: 3000,
          path: endpoint,
          queryParameters: {'id': roomId.toString(), 'name': name},
        ),
      );
      await newChannel.ready;
      channel = newChannel;
    } catch (e) {
      channel = null;
      throw Exception(e);
    }
  }

  Stream<dynamic> get messages => channel!.stream;

  void send(dynamic s) {
    try {
      channel!.sink.add(jsonEncode(s));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> closeService() async {
    await channel?.sink.close();
    channel = null;
  }
}
