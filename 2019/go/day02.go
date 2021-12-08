package main

import (
	"fmt"
	"io/ioutil"
	"os"

	intcode "github.com/robbkidd/aoc2021/intcode"
)

func main() {
	answerP1, _ := p1()
	fmt.Printf("Part 1: %d\n", answerP1)
	fmt.Printf("Part 2: %d\n", p2())
}

func p1() (int, error) {
	gravityAssistProgram := input()
	cpu := new(intcode.IntcodeComputer)
	cpu.Load(gravityAssistProgram)
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

func p2() int {
	noun, verb := findInputsForMoonLandingDate()
	return 100*noun + verb
}

func findInputsForMoonLandingDate() (int, int) {
	moonLandingDate := 19690720
	gravityAssistProgram := input()
	cpu := new(intcode.IntcodeComputer)
	for noun := 0; noun <= 99; noun++ {
		for verb := 0; verb <= 99; verb++ {
			cpu.Load(gravityAssistProgram)
			cpu.Hack(1, noun)
			cpu.Hack(2, verb)
			cpu.Run()
			output, _ := cpu.Read(0)
			if output == moonLandingDate {
				return noun, verb
			}
		}
	}
	return -1, -1
}

func input() string {
	bytes, err := ioutil.ReadFile("../inputs/day02-input.txt")
	if err != nil {
		fmt.Printf("Something's wicked with the input: %v\n", err)
		os.Exit(1)
	}
	return string(bytes)
}
