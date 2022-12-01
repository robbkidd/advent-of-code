package main

import (
	"fmt"
	"sort"
	"strconv"
	"strings"

	"github.com/robbkidd/aoc2022/tools"
)

const (
	example = `1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
`
)

func main() {
	input := realInput()
	fmt.Printf("Part 1: %v\n", p1(input))
	fmt.Printf("Part 2: %v\n", p2(input))
}

func p1(input []int) int {
	sort.Slice(input, func(i, j int) bool {
		return input[i] > input[j]
	})
	return input[0]
}

func p2(input []int) int {
	sort.Slice(input, func(i, j int) bool {
		return input[i] > input[j]
	})
	var top_three_total int
	for _, elf := range input[:3] {
		top_three_total += elf
	}
	return top_three_total
}

func exampleInput() []int {
	return parseInput(example)
}

func realInput() []int {
	return parseInput(tools.Read("day01"))
}

func parseInput(input string) []int {
	var elf_calories []int
	var current_elf_calories int
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		if line == "" {
			elf_calories = append(elf_calories, current_elf_calories)
			current_elf_calories = 0
		} else {
			calories, _ := strconv.Atoi(line)
			current_elf_calories += calories
		}
	}
	return elf_calories
}
