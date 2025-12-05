package day01

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
	rotations := parse(input)
	dial := 50
	zero_count := 0

	for _, rotation := range rotations {
		dial = (dial + rotation) % 100
		if dial == 0 {
			zero_count++
		}
	}
	return strconv.Itoa(zero_count)
}

func Part2(input string) string {
	rotations := parse(input)
	dial := 50
	zero_count := 0

	for _, rotation := range rotations {
		if rotation > 0 { // turning right is straightforward
			zero_count += (dial + rotation) / 100
		} else if dial > abs(rotation) { // turning left but the negative turn is smaller than the current dial
			continue
		} else if dial == 0 { // turning left when the dial is already at zero
			zero_count += abs(rotation) / 100
		} else { // turning left when the negative turn is larger than current dial (we'll pass 0 at least once)
			zero_count += 1 + abs(dial+rotation)/100
		}
		dial = (dial + rotation) % 100
		fmt.Printf("dial: %d, rotation: %d, zero count: %d\n", dial, rotation, zero_count)
	}
	return strconv.Itoa(zero_count)
}

func abs(n int) int {
	if n < 0 {
		return n * -1
	}
	return n
}

func parse(input string) []int {
	lines := strings.Split(input, "\n")
	rotations := make([]int, len(lines))

	for i, line := range lines {
		dir := line[0]
		num := line[1:]
		clicks, _ := strconv.Atoi(num)

		switch dir {
		case 'L':
			rotations[i] = clicks * -1
		case 'R':
			rotations[i] = clicks
		}
	}
	return rotations
}
