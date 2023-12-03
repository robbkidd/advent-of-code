package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExamplePart1(t *testing.T) {
	games := parseInput(example)
	assert.Equal(t,
		8,
		p1(games))
}

func TestExamplePart2(t *testing.T) {
	games := parseInput(example)
	assert.Equal(t,
		2286,
		p2(games))
}

func TestGameFromLine(t *testing.T) {
	game := GameFromLine("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
	assert.Equal(t, game.Id, 1)
	assert.Equal(t, len(game.Sets), 3)
}

func TestPossible(t *testing.T) {
	testCases := []struct {
		desc                string
		gameInput           string
		expectedPossibility bool
	}{
		{
			desc:                "Game 1",
			gameInput:           "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
			expectedPossibility: true,
		},
		{
			desc:                "Game 3",
			gameInput:           "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
			expectedPossibility: false,
		},
	}
	for _, tC := range testCases {
		t.Run(tC.desc, func(t *testing.T) {
			game := GameFromLine(tC.gameInput)
			assert.Equal(t, tC.expectedPossibility, game.possible())
		})
	}
}

func TestSetPower(t *testing.T) {
	set := Set{"blue": 6, "green": 2, "red": 4}

	assert.Equal(t, 48, set.power())
}

func TestSetsFromLine(t *testing.T) {
	sets := SetsFromLine("3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
	assert.Equal(t, sets[0]["blue"], 3)
	assert.Equal(t, sets[0]["green"], 0)
}

const (
	example = `Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
`
)
