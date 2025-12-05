package day03

import (
	"fmt"
	"log"
	"robbkidd/aoc2025/utils"
	"strconv"
	"strings"
)

func Run() {
	input, err := utils.ReadInput()
	if err != nil {
		log.Fatal("Couldn't read real input")
	}
	fmt.Printf("Part1: %s\n", Part1(input))
	fmt.Printf("Part2: %s\n", Part2(input))
}

func Part1(input string) string {
	return ""
}

func Part2(input string) string {
	return ""
}

type bank []int

func parse(input string) []bank {
	lines := strings.Split(input, "\n")
	banks := make([]bank, len(lines))
	
	for i, line := range lines {
		strings.S
		banks[i], _ = strconv.Atoi(line)
	}

	return banks
}
