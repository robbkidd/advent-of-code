package main

import (
	"fmt"
	"sort"
	"strings"

	"github.com/robbkidd/aoc2022/tools"
)

func main() {
	input := strings.Trim(tools.Read("day06"), "\n")
	fmt.Printf("Part 1: %v\n", scanForMarker(input, 4))
	fmt.Printf("Part 2: %v\n", scanForMarker(input, 14))
}

func scanForMarker(buffer string, packetLength int) int {
	lookback := packetLength - 1
	for scan := lookback; scan < len(buffer); scan++ {
		if packetLength == len(uniqSorted(buffer[(scan-lookback):(scan+1)])) {
			return scan + 1
		}
	}
	return -1
}

func uniqSorted(s string) string {
	seen := struct{}{}
	chars := make(map[rune]struct{})
	for _, char := range s {
		chars[char] = seen
	}
	var uniqRunes []rune
	for char := range chars {
		uniqRunes = append(uniqRunes, char)
	}
	sort.Slice(uniqRunes, func(i, j int) bool {
		return i < j
	})
	return string(uniqRunes)
}
