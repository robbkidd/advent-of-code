package day01_test

import (
	"testing"

	"robbkidd/aoc2025/day01"
	"robbkidd/aoc2025/utils"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func Test_Part1(t *testing.T) {
	input, err := utils.ReadExampleInput()
	require.NoError(t, err)

	result := day01.Part1(input)
	assert.Equal(t, "3", result)
}

func Test_Part2(t *testing.T) {
	input, err := utils.ReadExampleInput()
	require.NoError(t, err)

	result := day01.Part2(input)
	assert.Equal(t, "6", result)
}
