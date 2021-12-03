package main

import (
	"fmt"

	"github.com/robbkidd/aoc2021/input"
)

func main() {
	report := input.Lines(input.Read("day__"))
	fmt.Printf("Part 1: %v\n", p1())
	fmt.Printf("Part 2: %v\n", p2())
}
