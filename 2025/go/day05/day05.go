package day05

import (
	"fmt"
	"log"
	"robbkidd/aoc2025/utils"
	"slices"
	"sort"
	"strconv"
	"strings"
)

func Run() {
	input, err := utils.ReadInput()
	if err != nil {
		log.Fatal("Couldn't read real input")
	}
	fmt.Printf("Part1: %s\n", Part1(input))
	fmt.Printf("Part2: %s\n", Part2(input))
}

func Part1(input string) string {
	ranges, ids := parse(input)
	fresh_ingredients := 0
	for _, id := range ids {
		for _, r := range ranges {
			if r.Contains(id) {
				fresh_ingredients++
				break
			}
		}
	}
	return strconv.Itoa(fresh_ingredients)
}

func Part2(input string) string {
	var err error
	ranges, _ := parse(input)
	sort.Slice(ranges, func(i, j int) bool { return ranges[i].Lower < ranges[j].Lower })
	uniqueRanges := []Range{}
	for _, inputRange := range ranges {
		hit := slices.IndexFunc(uniqueRanges, func(uniq Range) bool { return uniq.Overlaps(inputRange) })
		if hit == -1 {
			uniqueRanges = append(uniqueRanges, inputRange)
		} else {
			uniqueRanges[hit], err = uniqueRanges[hit].Combine(inputRange)
			if err != nil {
				fmt.Printf("combining didn't work: %v + %v", uniqueRanges[hit], inputRange)
			}
		}
	}
	allFreshIDs := 0
	for _, uniqueRange := range uniqueRanges {
		allFreshIDs += uniqueRange.Count()
	}
	return strconv.Itoa(allFreshIDs)
}

type Range struct {
	Lower, Upper int
}

func (r Range) ToString() string {
	return fmt.Sprintf("(%d..%d)", r.Lower, r.Upper)
}

func (r Range) Count() int {
	return r.Upper - r.Lower + 1 // today's range is inclusive
}

func (r Range) Contains(id int) bool {
	return r.Lower <= id && id <= r.Upper
}

func (r Range) Overlaps(other Range) bool {
	return r.Contains(other.Lower) || r.Contains(other.Upper)
}

func (r Range) Combine(other Range) (Range, error) {
	if !r.Overlaps(other) {
		return Range{}, fmt.Errorf("can't combine ranges that don't overlap: %v, %v", r, other)
	}
	return Range{Lower: min(r.Lower, other.Lower), Upper: max(r.Upper, other.Upper)}, nil
}

func parse(input string) ([]Range, []int) {
	sections := strings.Split(input, "\n\n")
	ranges_in := strings.Split(sections[0], "\n")
	ids_in := strings.Split(sections[1], "\n")

	ranges := make([]Range, len(ranges_in))
	for i, r := range ranges_in {
		bounds := strings.Split(r, "-")
		lower, _ := strconv.Atoi(bounds[0])
		upper, _ := strconv.Atoi(bounds[1])
		ranges[i] = Range{Lower: lower, Upper: upper}
	}

	ids := make([]int, len(ids_in))
	for i, id := range ids_in {
		ids[i], _ = strconv.Atoi(id)
	}

	return ranges, ids
}
