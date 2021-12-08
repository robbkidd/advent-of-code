package intcode

import (
	"strconv"
	"strings"
)

type IntcodeComputer struct {
	program string
	memory  []int
	pointer int
	status  string
}

func programToMemory(program string) []int {
	var theInts []int
	splits := strings.Split(program, ",")
	for _, num := range splits {
		n, _ := strconv.Atoi(num)
		theInts = append(theInts, n)
	}
	return theInts
}
