package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/robbkidd/aoc2021/tools"
)

func main() {
	crabs := realInput()
	fmt.Printf("Part 1: %v\n", p1(crabs))
	fmt.Printf("Part 2: %v\n", p2(crabs))
}

func p1(crabs []int) int {
	min, max := tools.MinMax(crabs)
	var fuelCosts []int
	for pos := min; pos <= max; pos++ {
		fuelCosts = append(fuelCosts, naiveFuelCost(crabs, pos))
	}
	minFuelCost, _ := tools.MinMax(fuelCosts)
	return minFuelCost
}

func p2(crabs []int) int {
	min, max := tools.MinMax(crabs)
	var fuelCosts []int
	for pos := min; pos <= max; pos++ {
		fuelCosts = append(fuelCosts, crabEngineeringFuelCost(crabs, pos))
	}
	minFuelCost, _ := tools.MinMax(fuelCosts)
	return minFuelCost
}

func crabEngineeringFuelCost(crabs []int, targetPosition int) int {
	cost := 0
	for _, crab := range crabs {
		difference := crab - targetPosition
		if difference < 0 {
			difference = -difference
		}
		cost += difference * (difference + 1) / 2
	}
	return cost
}

func naiveFuelCost(crabs []int, targetPosition int) int {
	cost := 0
	for _, crab := range crabs {
		difference := crab - targetPosition
		if difference < 0 {
			difference = -difference
		}
		cost += difference
	}
	return cost
}

func exampleInput() []int {
	return parseInput(`16,1,2,0,4,2,7,1,2,14`)
}

func realInput() []int {
	return parseInput(tools.Read("day07"))
}

func parseInput(input string) []int {
	numberStrings := strings.Split(input, ",")
	var numbers []int
	for _, num := range numberStrings {
		n, _ := strconv.Atoi(num)
		numbers = append(numbers, n)
	}
	return numbers
}
