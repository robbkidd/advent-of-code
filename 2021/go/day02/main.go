package main

import (
	"fmt"
	"strconv"
	"strings"

	input "github.com/robbkidd/aoc2021/tools"
)

func main() {
	planned_course := input.Lines(input.Read("day02"))
	fmt.Printf("Part 1: %v\n", part1(planned_course))
	fmt.Printf("Part 2: %v\n", part2(planned_course))
}

func part1(course []string) int {
	horiz_pos := 0
	depth := 0
	for _, step := range course {
		command := ParseCommand(step)
		switch command.direction {
		case "up":
			depth -= command.units
		case "down":
			depth += command.units
		case "forward":
			horiz_pos += command.units
		}
	}
	return horiz_pos * depth
}

func part2(course []string) int {
	horiz_pos := 0
	depth := 0
	aim := 0
	for _, step := range course {
		command := ParseCommand(step)
		switch command.direction {
		case "up":
			aim -= command.units
		case "down":
			aim += command.units
		case "forward":
			horiz_pos += command.units
			depth += aim * command.units
		}
	}
	return horiz_pos * depth
}

type Command struct {
	direction string
	units     int
}

func ParseCommand(line string) Command {
	var c Command
	split := strings.Split(line, " ")
	c.direction = split[0]
	c.units, _ = strconv.Atoi(split[1])
	return c
}
