package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/robbkidd/aoc2022/tools"
)

func main() {
	input := parseInput(tools.Read("day04"))
	fmt.Printf("Part 1: %v\n", p1(input))
	fmt.Printf("Part 2: %v\n", p2(input))
}

func p1(lines []string) int {
	var fullyCovered int
	for _, line := range lines {
		pair := strings.Split(line, ",")
		left := strings.Split(pair[0], "-")
		right := strings.Split(pair[1], "-")
		leftStart, _ := strconv.Atoi(left[0])
		leftStop, _ := strconv.Atoi(left[1])
		rightStart, _ := strconv.Atoi(right[0])
		rightStop, _ := strconv.Atoi(right[1])

		if leftStart >= rightStart && leftStop <= rightStop {
			fullyCovered++
			continue
		}

		if leftStart <= rightStart && leftStop >= rightStop {
			fullyCovered++
			continue
		}
	}
	return fullyCovered
}

func p2(input []string) int {
	return 0
}

type Pair struct {
	left  Assignment
	right Assignment
}
type Assignment struct {
	start int
	stop  int
}

func parseInput(input string) []string {
	return tools.Lines(input)
}
