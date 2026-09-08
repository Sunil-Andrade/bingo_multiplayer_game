package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
)

func createGame(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}

	defer conn.Close()

	_, message, err := conn.ReadMessage()

	var g Res
	json.Unmarshal(message, &g)

	maxPlayers := 2
	if val, ok := g.PayLoad["playercount"].(float64); ok {
		maxPlayers = int(val)
	}
	fmt.Println(maxPlayers)
	id := generateRandom()

	gameState := &GameState{
		message: make(chan *Res),
	}

	game := &Game{
		gameId:           id,
		players:          make(map[int]*Player),
		maxPlayers:       maxPlayers,
		count:            0,
		addPlayerChan:    make(chan *Player),
		removePlayerchan: make(chan *Player),
		action:           make(chan *Res),
		turn:             make([]*Player, 0, maxPlayers),
		whosTurn:         0,
		startGameChan:    make(chan bool),
		gameState:        *gameState,
		ready:            0,
		gameStarted:      true,
		winners:          make([]*Player, 0, maxPlayers),
	}

	player := &Player{
		conn:       conn,
		playerName: g.PayLoad["name"].(string),
		playerId:   generateRandom(),
		nums:       make(map[int]int),
		bingo:      []int{},
		toWin:      0,
	}

	games[id] = game

	m := &Res{
		Flag: g.Flag,
		PayLoad: map[string]any{
			"gameid":    id,
			"playernum": g.PayLoad["playercount"],
			"playerNames": []string{
				player.playerName,
			},
		},
	}

	//writing part
	err = conn.WriteJSON(m)
	if err != nil {
		fmt.Println("write error:", err)

	}

	go game.Run()
	handleconnection(game, player)

}

// handleconnection
func handleconnection(g *Game, p *Player) {

	g.addPlayerChan <- p

	for {
		_, message, err := p.conn.ReadMessage()
		if err != nil {
			log.Println(err)
			return
		}

		var action Res
		json.Unmarshal(message, &action)

		switch action.Flag {
		case 3:
			act := &Res{
				Flag:    3,
				PayLoad: map[string]any{},
			}

			g.action <- act
			startTimer(30, g)
		case 12:
			arr, ok := action.PayLoad["matrix"].([]interface{})
			if !ok {
				fmt.Println("Failled ")
			}
			addMatrix(arr, p)
			g.ready++
			if g.ready == len(g.turn) && g.gameStarted {
				g.startGameChan <- true
			}
			fmt.Println(p.nums)
		case 20:
			fmt.Println(".............")
			if g.turn[g.whosTurn].playerId == p.playerId {
				g.gameState.message <- &action
			}
		default:
			fmt.Println("message channel full")
		}

	}
}

func joinGame(w http.ResponseWriter, r *http.Request) {

	conn, err := upgrader.Upgrade(w, r, nil)

	id := r.URL.Query().Get("id")
	name := r.URL.Query().Get("name")

	gameId, err := strconv.Atoi(id)

	_, ok := games[gameId]

	if !ok {
		conn.WriteJSON(Res{
			Flag: -1,
			PayLoad: map[string]any{
				"res": "wrong code",
			},
		})
		conn.Close()
		return
	}

	if err != nil {
		log.Println("Error")
		return
	}

	game := games[gameId]

	if game.count >= game.maxPlayers {
		conn.WriteJSON(Res{
			Flag: -1,
			PayLoad: map[string]any{
				"res": "Maximum players reached",
			},
		})
		return
	}

	player := &Player{
		playerId:   generateRandom(),
		conn:       conn,
		playerName: name,
		nums:       map[int]int{},
		toWin:      0,
		bingo:      []int{},
	}

	handleconnection(game, player)

}
