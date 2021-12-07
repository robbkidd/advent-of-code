package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestInputParsing(t *testing.T) {
	assert.Equal(t,
		[]int{16, 1, 2, 0, 4, 2, 7, 1, 2, 14},
		exampleInput(),
		"nope")
}

func TestExamplePart1(t *testing.T) {
	assert.Equal(t,
		37,
		p1(exampleInput()))
}

func TestExamplePart2(t *testing.T) {
	assert.Equal(t,
		168,
		p2(exampleInput()))
}
