package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExamplePart1(t *testing.T) {
	assert.Equal(t,
		24000,
		p1(exampleInput()))
}

func TestExamplePart2(t *testing.T) {
	assert.Equal(t,
		45000,
		p2(exampleInput()))
}

func TestParseInput(t *testing.T) {
	assert.Equal(t,
		[]int{6000, 4000, 11000, 24000, 10000},
		parseInput(example),
	)
}
