package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExamplePart1(t *testing.T) {
	assert.Equal(t,
		'lolwut',
		p1(parseInput(example)))
}

func TestExamplePart2(t *testing.T) {
	assert.Equal(t,
		'heyo',
		p2(parseInput(example)))
}

const (
	example = ``
)
