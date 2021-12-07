package main

import (
	"fmt"

	"github.com/robbkidd/aoc2021/tools"
)

func main() {
	input := realInput()
	fmt.Printf("Part 1: %v\n", p1())
	fmt.Printf("Part 2: %v\n", p2())
}

func exampleInput() []int {
	return parseInput(``)
}

func realInput() []int {
	return parseInput(tools.Read("day__"))
}

func parseInput(input string) {

	return
}
