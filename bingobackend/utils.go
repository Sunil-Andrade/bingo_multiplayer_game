package main

import (
	"math/rand"
	"time"
)

func generateRandom() int {
	return 100000 + rand.Intn(900000)
}

func startTimer(totalTime int, g *Game) {
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()

	remaining := totalTime

	for remaining >= 0 {
		g.action <- &Res{
			Flag: 4,
			PayLoad: map[string]any{
				"remtime": remaining,
			},
		}

		if remaining == 0 {
			g.action <- &Res{
				Flag:    5,
				PayLoad: map[string]any{},
			}
			return
		}

		<-ticker.C
		remaining--
	}
}

// func sendTimer(p *Player, state *GameState) {
// 	ticker := time.NewTicker(time.Second)
// 	defer ticker.Stop()

// 	remaining := 30

// 	for remaining >= 0 {
// 		mess := &Res{
// 			Flag: 4,
// 			PayLoad: map[string]any{
// 				"remtime": remaining,
// 			},
// 		}

// 		p.conn.WriteJSON(mess)

// 		if remaining == 0 {
// 			mess := &Res{
// 				Flag:    7,
// 				PayLoad: map[string]any{},
// 			}
// 			p.conn.WriteJSON(mess)
// 			return
// 		}

// 		select {
// 		case <-ticker.C:
// 			remaining--

// 		case <-state.message:
// 			return

// 		}
// 	}

// }

func addMatrix(arr []interface{}, player *Player) {
	matrix := make([]int, len(arr))

	for i, v := range arr {
		matrix[i] = int(v.(float64))
	}

	player.bingo = make([]int, len(matrix))

	for ind, i := range matrix {
		player.nums[i] = ind
		player.bingo[ind] = i
	}
}
