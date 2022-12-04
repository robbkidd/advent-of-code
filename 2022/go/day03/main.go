package main

import (
	"fmt"

	"github.com/robbkidd/aoc2022/tools"
)

func main() {
	input := parseInput(tools.Read("day03"))
	fmt.Printf("Part 1: %v\n", p1(input))
	fmt.Printf("Part 2: %v\n", p2(input))
}

func p1(sacks []string) int {
	var prioritySum int
	for _, sack := range sacks {
		compartments := splitRuckSack(sack)
		prioritySum += priorityOf(
			commonItems(compartments[0], compartments[1]),
		)
	}
	return prioritySum
}

func p2(sacks []string) int {
	var prioritySum int
	for i := 0; i < len(sacks); i += 3 {
		prioritySum += priorityOf(
			commonItems(
				commonItems(sacks[i], sacks[i+1]),
				sacks[i+2],
			),
		)
	}
	return prioritySum
}

func commonItems(first, second string) string {
	shared := struct{}{}
	items := make(map[rune]struct{})
	for _, itemA := range first {
		for _, itemB := range second {
			if itemA == itemB {
				items[itemB] = shared
			}
		}
	}
	var common string
	for k := range items {
		common += string(k)
	}
	return common
}

func splitRuckSack(sack string) []string {
	middle := len(sack) / 2
	return []string{
		sack[:middle],
		sack[middle:],
	}
}

func priorityOf(item string) int {
	if len(item) != 1 {
		panic(fmt.Errorf("what is this? '%s'", item))
	}
	r := item[0]
	if int(r) < 96 {
		return int(r) - 38
	}
	return int(r) - 96
}

func parseInput(input string) []string {
	return tools.Lines(input)
}
