package main

import (
	"fmt"
	"os"
	"robbkidd/aoc2025/day01"
	"robbkidd/aoc2025/day02"
)

func main() {
	day := os.Getenv("DAY")
	switch day {
	case "01":
		day01.Run()
	case "02":
		day02.Run()
	default:
		fmt.Printf("I don't recognize %s as a day ... yet?\n", day)
		os.Exit(1)
	}
}
