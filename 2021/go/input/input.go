package input

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func JustGiveMeIntsMan(numbersNotYetTheirTrueSelves []string) []int {
	var theInts []int
	for _, line := range numbersNotYetTheirTrueSelves {
		number, _ := strconv.Atoi(line)
		theInts = append(theInts, number)
	}
	return theInts
}

func Lines(input string) []string {
	return strings.Split(input, "\n")
}

func Read(day string) string {
	bytes, err := ioutil.ReadFile(fmt.Sprintf("../inputs/%v-input.txt", day))
	if err != nil {
		fmt.Printf("Something's wicked with the input: %v\n", err)
		os.Exit(1)
	}
	return string(bytes)
}
