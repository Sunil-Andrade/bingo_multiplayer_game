import 'package:bingo_app/bloc/bingo_bloc.dart';
import 'package:bingo_app/pages/make_room.dart';
import 'package:bingo_app/service/websocket_service.dart';

import 'package:bingo_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;

void main() {
  runApp(
    BlocProvider(
      create: (context) => BingoBloc(websocketService: WebsocketService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
      ),
      home: MakeRoom(),
    );
  }
}
