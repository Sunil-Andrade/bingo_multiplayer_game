package main

import (
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{}

// it maintains games
var games = make(map[int]*Game)

func main() {

	http.HandleFunc("/creategame", createGame)
	http.HandleFunc("/joingame", joinGame)

	http.ListenAndServe(":3000", nil)
}
