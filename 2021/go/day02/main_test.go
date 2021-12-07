package main

import (
	"testing"

	input "github.com/robbkidd/aoc2021/tools"
	"github.com/stretchr/testify/assert"
)

var (
	example_input = `forward 5
down 5
forward 8
up 3
down 8
forward 2
`
)

func TestInputParsing(t *testing.T) {
	command := ParseCommand("forward 5")
	assert.Equal(t, "forward", command.direction, "nope")
	assert.Equal(t, 5, command.units, "uh uh")

	for _, step := range input.Lines(example_input) {
		_ = ParseCommand(step) // does not panic
	}
}

func TestExamplePart1(t *testing.T) {
	example_course := input.Lines(example_input)
	assert.Equal(t, 150, part1(example_course), "Don't got it yet.")
}

func TestExamplePart2(t *testing.T) {
	example_course := input.Lines(example_input)
	assert.Equal(t, 900, part2(example_course), "Don't got it yet.")
}
