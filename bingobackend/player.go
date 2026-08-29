package main

import "github.com/gorilla/websocket"

type Player struct {
	playerId   int
	playerName string
	conn       *websocket.Conn
	nums       map[int]int
	bingo      []int
	toWin      int
}
