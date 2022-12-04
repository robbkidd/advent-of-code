package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExamplePart1(t *testing.T) {
	assert.Equal(t,
		2,
		p1(parseInput(example)))
}

func TestExamplePart2(t *testing.T) {
	assert.Equal(t,
		4,
		p2(parseInput(example)))
}

const (
	example = `2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
`
)
