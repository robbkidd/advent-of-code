package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExamplePart1(t *testing.T) {
	assert.Equal(t,
		24000,
		p1(parseInput(example)))
}

func TestExamplePart2(t *testing.T) {
	assert.Equal(t,
		45000,
		p2(parseInput(example)))
}

func TestParseInput(t *testing.T) {
	assert.Equal(t,
		[]int{6000, 4000, 11000, 24000, 10000},
		parseInput(example),
	)
}

const (
	example = `1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
`
)
