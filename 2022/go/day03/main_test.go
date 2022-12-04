package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExamplePart1(t *testing.T) {
	assert.Equal(t,
		157,
		p1(parseInput(example)))
}

func TestExamplePart2(t *testing.T) {
	assert.Equal(t,
		70,
		p2(parseInput(example)))
}

func TestSplitRucksack(t *testing.T) {
	assert.Equal(t,
		[]string{"vJrwpWtwJgWr", "hcsFMMfFFhFp"},
		splitRuckSack("vJrwpWtwJgWrhcsFMMfFFhFp"),
	)
}

func TestCommonItem(t *testing.T) {
	assert.Equal(t,
		"p",
		commonItems("vJrwpWtwJgWr", "hcsFMMfFFhFp"),
	)

	firstThree := parseInput(firstThreeLines)
	assert.Equal(t,
		"V",
		commonItems(
			commonItems(firstThree[0], firstThree[1]),
			firstThree[2],
		),
	)
}

func TestPriorityOf(t *testing.T) {
	assert.Equal(t, 1, priorityOf("a"))
	assert.Equal(t, 26, priorityOf("z"))
	assert.Equal(t, 27, priorityOf("A"))
	assert.Equal(t, 52, priorityOf("Z"))
}

const (
	example = `vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
`

	firstThreeLines = `TZZjzzZLfZbzgzZNNJZjwCVbwMmhwCbBpCMMBCbM
qRQPDqnWFQDtCCBQmQwmGGVG
FPllWPDPrncZsLVrgSZTSZ
`
)
