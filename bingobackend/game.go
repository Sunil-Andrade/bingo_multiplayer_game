package main

import (
	"fmt"
)

type Game struct {
	gameId           int
	players          map[int]*Player
	maxPlayers       int
	count            int
	action           chan *Res
	addPlayerChan    chan *Player
	removePlayerchan chan *Player
	turn             []*Player
	whosTurn         int
	startGameChan    chan bool
	gameState        GameState
	ready            int
	gameStarted      bool
	winners          []*Player
}

func (g *Game) addPlayer(p *Player) {

	g.players[p.playerId] = p
	g.turn = append(g.turn, p)
	players := []string{}
	for _, player := range g.players {
		players = append(players, player.playerName)
	}

	res := &Res{
		Flag: 2,
		PayLoad: map[string]any{
			"max":     g.maxPlayers,
			"players": players,
		},
	}
	g.broadcastMessage(res)
}

func (g *Game) removePlayer(p *Player) {
	delete(g.players, p.playerId)
}

func (g *Game) broadcastMessage(m *Res) {
	for _, player := range g.players {
		err := player.conn.WriteJSON(m)
		if err != nil {
			fmt.Println("Error braodcating message: ", err)
			return
		}
	}
}

func (g *Game) Run() {
	for {
		select {
		case player := <-g.addPlayerChan:
			g.addPlayer(player)
			g.count++
		case player := <-g.removePlayerchan:
			g.removePlayer(player)
		case action := <-g.action:
			g.broadcastMessage(action)
		case <-g.startGameChan:
			g.gameState.run(g)
		}
	}
}
