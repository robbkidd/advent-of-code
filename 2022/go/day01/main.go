package main

import (
	"fmt"
	"sort"
	"strconv"
	"strings"

	"github.com/robbkidd/aoc2022/tools"
)

func main() {
	input := parseInput(tools.Read("day01"))

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
	return input[0] + input[1] + input[2]
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
