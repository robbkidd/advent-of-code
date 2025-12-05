package day03_test

import (
	"testing"

	"robbkidd/aoc2025/day03"
	"robbkidd/aoc2025/utils"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func Test_Part1(t *testing.T) {
	input, err := utils.ReadExampleInput()
	require.NoError(t, err)

	result := day03.Part1(input)
	assert.Equal(t, "1227775554", result)
}

func Test_Part2(t *testing.T) {
	input, err := utils.ReadExampleInput()
	require.NoError(t, err)

	result := day03.Part2(input)
	assert.Equal(t, "4174379265", result)
}
