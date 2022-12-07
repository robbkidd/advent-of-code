package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestScanForMarker(t *testing.T) {
	testCases := []struct {
		input                string
		startOfPacketMarker  int
		startOfMessageMarker int
	}{
		{
			input:                "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
			startOfPacketMarker:  7,
			startOfMessageMarker: 19,
		},
		{
			input:                "bvwbjplbgvbhsrlpgdmjqwftvncz",
			startOfPacketMarker:  5,
			startOfMessageMarker: 23,
		},
		{
			input:                "nppdvjthqldpwncqszvftbrmjlhg",
			startOfPacketMarker:  6,
			startOfMessageMarker: 23,
		},
		{
			input:                "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
			startOfPacketMarker:  10,
			startOfMessageMarker: 29,
		},
		{
			input:                "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw",
			startOfPacketMarker:  11,
			startOfMessageMarker: 26,
		},
	}
	for _, tC := range testCases {
		t.Run(tC.input, func(t *testing.T) {
			t.Run("packet", func(t *testing.T) {
				assert.Equal(t,
					tC.startOfPacketMarker,
					scanForMarker(tC.input, 4),
					"Failed expected packet lock",
				)
			})
			t.Run("message", func(t *testing.T) {
				assert.Equal(t,
					tC.startOfMessageMarker,
					scanForMarker(tC.input, 14),
					"Failed expected message lock",
				)
			})
		})
	}
}

func TestUniqSorted(t *testing.T) {
	assert.Equal(t,
		"abc",
		uniqSorted("aabbccaaa"),
	)
}
