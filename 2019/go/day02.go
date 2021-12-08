package main

import (
	"fmt"
	"io/ioutil"
	"os"

	intcode "github.com/robbkidd/aoc2021/intcode"
)

func main() {
	answerP1, _ := p1()
	fmt.Printf("Part 1: %v\n", answerP1)
}

func p1() (int, error) {
	cpu := new(intcode.IntcodeComputer)
	cpu.Load(input())
	// restore the gravity assist program
	// to the "1202 program alarm" state
	cpu.Hack(1, 12)
	cpu.Hack(2, 2)

	err := cpu.Run()
	if err != nil {
		return -0, fmt.Errorf("🖥😢 %v", err)
	}

	output, err := cpu.Read(0)
	if err != nil {
		return -0, fmt.Errorf("🖥😢 %v", err)
	}
	return output, nil
}

func input() string {
	bytes, err := ioutil.ReadFile("../inputs/day02-input.txt")
	if err != nil {
		fmt.Printf("Something's wicked with the input: %v\n", err)
		os.Exit(1)
	}
	return string(bytes)
}
