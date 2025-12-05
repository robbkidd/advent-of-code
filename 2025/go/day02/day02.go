package day02

import (
	"fmt"
	"log"
	"robbkidd/aoc2025/utils"
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
	ranges := parse(input)
	invalid_id_sum := 0
	for _, r := range ranges {
		for id := r.start; id <= r.end; id++ {
			if repeats_twice(id) {
				invalid_id_sum += id
			}
		}
	}
	return strconv.Itoa(invalid_id_sum)
}

func repeats_twice(id int) bool {
	id_str := strconv.Itoa(id)
	if len(id_str)%2 > 0 {
		return false
	}
	return id_str[:len(id_str)/2] == id_str[len(id_str)/2:]
}

func Part2(input string) string {
	ranges := parse(input)
	invalid_id_sum := 0
	for _, r := range ranges {
		for id := r.start; id <= r.end; id++ {
			if repeats_at_least_twice(id) {
				invalid_id_sum += id
			}
		}
	}
	return strconv.Itoa(invalid_id_sum)
}

func repeats_at_least_twice(id int) bool {
	id_str := strconv.Itoa(id)
	doubled := id_str + id_str
	doubled_and_snipped := doubled[1 : len(doubled)-1]
	return strings.Contains(doubled_and_snipped, id_str)
}

type Range struct {
	start, end int
}

func parse(input string) []Range {
	ranges_in := strings.Split(input, ",")
	ranges := make([]Range, len(ranges_in))

	for i, range_in := range ranges_in {
		bounds := strings.Split(range_in, "-")
		r := Range{}
		r.start, _ = strconv.Atoi(bounds[0])
		r.end, _ = strconv.Atoi(bounds[1])
		ranges[i] = r
	}
	return ranges
}
