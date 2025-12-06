package day05_test

import (
	"fmt"
	"testing"

	"robbkidd/aoc2025/day05"
	"robbkidd/aoc2025/utils"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func Test_Part1(t *testing.T) {
	input, err := utils.ReadExampleInput()
	require.NoError(t, err)

	result := day05.Part1(input)
	assert.Equal(t, "3", result)
}

func Test_Part2(t *testing.T) {
	input, err := utils.ReadExampleInput()
	require.NoError(t, err)

	result := day05.Part2(input)
	assert.Equal(t, "14", result)
}

func Test_Range_Contains(t *testing.T) {
	testCases := []struct {
		aRange   day05.Range
		num      int
		expected bool
	}{
		{
			aRange:   day05.Range{Lower: 12, Upper: 18},
			num:      12,
			expected: true,
		},
		{
			aRange:   day05.Range{Lower: 12, Upper: 18},
			num:      18,
			expected: true,
		},
		{
			aRange:   day05.Range{Lower: 12, Upper: 18},
			num:      15,
			expected: true,
		},
		{
			aRange:   day05.Range{Lower: 12, Upper: 18},
			num:      11,
			expected: false,
		},
	}
	for _, tC := range testCases {
		t.Run(fmt.Sprintf("%v ? %d", tC.aRange, tC.num), func(t *testing.T) {
			assert.Equal(t, tC.expected, tC.aRange.Contains(tC.num))
		})
	}
}

func Test_Range_Count(t *testing.T) {
	testCases := []struct {
		aRange day05.Range
		count  int
	}{
		{
			aRange: day05.Range{Lower: 12, Upper: 18},
			count:  7, // today's range is inclusive
		},
	}
	for _, tC := range testCases {
		t.Run(fmt.Sprintf("%v", tC.aRange), func(t *testing.T) {
			assert.Equal(t, tC.count, tC.aRange.Count())
		})
	}
}
