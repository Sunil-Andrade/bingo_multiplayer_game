package main

import (
	"fmt"
	"time"
)

type GameState struct {
	message chan *Res
}

func (gameState *GameState) run(game *Game) {

	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()

	remaining := 30

	marked := -1

	choosen := make(map[int]bool)

	choosen[marked] = true

	for {

		if len(game.winners) != 0 {

			players := []string{}
			for _, player := range game.winners {
				players = append(players, player.playerName)
			}

			//
			mess := &Res{
				Flag: 66,
				PayLoad: map[string]any{
					"winners": players,
				},
			}
			game.broadcastMessage(mess)
			return
		}

		if game.whosTurn >= len(game.turn) {
			game.whosTurn = 0
		}

		player := game.turn[game.whosTurn]

		for _, pl := range game.players {

			name := &Res{
				Flag: 10,
				PayLoad: map[string]any{
					"name":   player.playerName,
					"marked": marked,
					"score":  pl.toWin,
				},
			}
			fmt.Println("Running")
			pl.conn.WriteJSON(name)
			if pl.playerId != player.playerId {
				err := pl.conn.WriteJSON(name)
				if err != nil {
					fmt.Println("Error braodcating message: ", err)
					return
				}
			}

		}

		mess := &Res{
			Flag: 4,
			PayLoad: map[string]any{
				"remtime": remaining,
			},
		}

		player.conn.WriteJSON(mess)

		if remaining == 0 {
			game.whosTurn++
			remaining = 10
		}

		select {
		case <-ticker.C:
			remaining--

		case m := <-gameState.message:
			game.gameStarted = false

			mar := m.PayLoad["selected"].(float64)
			marked = int(mar)
			if choosen[marked] && remaining > 0 {
				continue
			} else {
				gameState.play(marked, game)
				choosen[marked] = true
				game.whosTurn++
				remaining = 30
			}

		}
	}
}

func (state *GameState) mark(marked int, player *Player) {
	index := player.nums[marked]
	player.bingo[index] = -1

}

func (state *GameState) play(marked int, game *Game) {
	for _, player := range game.players {
		state.mark(marked, player)
		state.checkWinner(player)
		fmt.Println(player.toWin)
		if player.toWin == 5 {
			game.winners = append(game.winners, player)
		}
	}
}

func (state *GameState) checkWinner(p *Player) {
	p.toWin = 0
	if loopez(0, 4, 1, p.bingo) {
		p.toWin++
	}
	if loopez(5, 9, 1, p.bingo) {
		p.toWin++
	}
	if loopez(10, 14, 1, p.bingo) {
		p.toWin++
	}
	if loopez(15, 19, 1, p.bingo) {
		p.toWin++
	}
	if loopez(20, 24, 1, p.bingo) {
		p.toWin++
	}
	if loopez(0, 24, 6, p.bingo) {
		p.toWin++
	}
	if loopez(4, 24, 4, p.bingo) {
		p.toWin++
	}
	if loopez(0, 20, 5, p.bingo) {
		p.toWin++
	}
	if loopez(1, 21, 5, p.bingo) {
		p.toWin++
	}
	if loopez(2, 22, 5, p.bingo) {
		p.toWin++
	}
	if loopez(3, 23, 5, p.bingo) {
		p.toWin++
	}
	if loopez(4, 24, 5, p.bingo) {
		p.toWin++
	}
}

func loopez(start int, end int, incr int, arr []int) bool {
	for i := start; i <= end; i += incr {
		if arr[i] != -1 {
			return false
		}
	}
	return true
}
