package main

import (
	"testing"

	input "github.com/robbkidd/aoc2021/tools"
	"github.com/stretchr/testify/assert"
)

var (
	example_input = `199
200
208
210
200
207
240
269
260
263
`
)

func TestCountingIncreases(t *testing.T) {
	example := input.JustGiveMeIntsMan(input.Lines(example_input))
	assert.Equal(t,
		7, increasesCount(example),
		"Unexpected count for the increases for the raw example input.",
	)
}

func TestCountingSlidingWindows(t *testing.T) {
	example := input.JustGiveMeIntsMan(input.Lines(example_input))
	assert.Equal(t,
		5, slidingWindowCount(example),
		"The count of increases in the sliding windows for the example input should be 5.",
	)
}
