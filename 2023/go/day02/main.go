package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/robbkidd/aoc2023/tools"
)

func main() {
	games := parseInput(tools.Read("day02"))

	fmt.Printf("Part 1: %v\n", p1(games))
	fmt.Printf("Part 2: %v\n", p2(games))
}

func p1(games []Game) (sumOfIds int) {
	for _, game := range games {
		if game.possible() {
			sumOfIds += game.Id
		}
	}
	return sumOfIds
}

func p2(games []Game) (sumOfPowers int) {
	var minSet Set
	for _, game := range games {
		minSet = Set{}
		for _, set := range game.Sets {
			for _, color := range []string{"blue", "green", "red"} {
				if set[color] > minSet[color] {
					minSet[color] = set[color]
				}
			}
		}
		sumOfPowers += minSet.power()
	}
	return sumOfPowers
}

func parseInput(input string) []Game {
	lines := tools.Lines(input)
	games := make([]Game, len(lines))

	for idx, line := range lines {
		games[idx] = GameFromLine(line)
	}

	return games
}

type Game struct {
	Id   int
	Sets []Set
}

// possible if the bag contained only
// 12 red cubes, 13 green cubes, and 14 blue cubes
func (g Game) possible() bool {
	for _, set := range g.Sets {
		if set["red"] > 12 || set["green"] > 13 || set["blue"] > 14 {
			return false
		}
	}
	return true
}

func GameFromLine(line string) Game {
	split := strings.Split(line, ": ")
	id, err := strconv.Atoi(strings.Split(split[0], " ")[1])
	if err != nil {
		panic("couldn't figure out a game ID")
	}

	return Game{
		Id:   id,
		Sets: SetsFromLine(split[1]),
	}
}

type Set map[string]int

func (s Set) power() int {
	return s["blue"] * s["green"] * s["red"]
}

func SetsFromLine(line string) []Set {
	bagReaches := strings.Split(line, "; ")
	sets := make([]Set, len(bagReaches))

	var set Set
	var err error
	for idx, handfulOfRandomCubes := range bagReaches {
		set = Set{}

		for _, cubesByColor := range strings.Split(handfulOfRandomCubes, ", ") {
			countAndColor := strings.Split(cubesByColor, " ")
			set[countAndColor[1]], err = strconv.Atoi(countAndColor[0])
			if err != nil {
				panic("couldn't convert a cube count to int")
			}
		}

		sets[idx] = set
	}

	return sets
}
