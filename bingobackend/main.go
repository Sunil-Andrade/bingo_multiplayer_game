package main

import (
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

// it maintains games
var games = make(map[int]*Game)

func main() {

	http.HandleFunc("/creategame", createGame)
	http.HandleFunc("/joingame", joinGame)

	http.ListenAndServe(":3000", nil)
}
