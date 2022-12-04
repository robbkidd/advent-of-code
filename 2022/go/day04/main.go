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
		pair := lineToPair(line)

		if fullyCovers(pair) {
			fullyCovered++
			continue
		}
	}
	return fullyCovered
}

func fullyCovers(pair Pair) bool {
	if pair.left.start >= pair.right.start && pair.left.stop <= pair.right.stop {
		return true
	}
	if pair.left.start <= pair.right.start && pair.left.stop >= pair.right.stop {
		return true
	}
	return false
}

func lineToPair(line string) Pair {
	p := strings.Split(line, ",")
	left := strings.Split(p[0], "-")
	right := strings.Split(p[1], "-")

	leftStart, _ := strconv.Atoi(left[0])
	leftStop, _ := strconv.Atoi(left[1])
	rightStart, _ := strconv.Atoi(right[0])
	rightStop, _ := strconv.Atoi(right[1])

	return Pair{
		left: Assignment{
			start: leftStart,
			stop:  leftStop,
		},
		right: Assignment{
			start: rightStart,
			stop:  rightStop,
		},
	}
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
