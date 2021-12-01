package main

import (
	"fmt"

	"github.com/robbkidd/aoc2021/input"
)

func main() {
	report := input.JustGiveMeIntsMan(input.Lines(input.Read("day01")))
	fmt.Printf("Part 1: %v\n", increasesCount(report))
	fmt.Printf("Part 2: %v\n", slidingWindowCount(report))
}

func increasesCount(depths []int) int {
	count := 0
	for i := 0; i < len(depths)-1; i++ {
		if depths[i] < depths[i+1] {
			count++
		}
	}
	return count
}

func slidingWindowCount(depths []int) int {
	var windowSums []int
	for i := 0; i < len(depths)-2; i++ {
		thisWindowSum := depths[i] + depths[i+1] + depths[i+2]
		windowSums = append(windowSums, thisWindowSum)
	}
	return increasesCount(windowSums)
}
