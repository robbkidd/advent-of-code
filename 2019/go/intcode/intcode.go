package intcode

import (
	"fmt"
	"strconv"
	"strings"
)

type IntcodeComputer struct {
	program string
	memory  []int
	pointer int
	status  string
}

func (c *IntcodeComputer) Load(program string) {
	c.program = program
	c.memory = programToMemory(c.program)
}

func (c *IntcodeComputer) Run() error {
	c.pointer = 0
	c.status = "running"
	for c.pointer < len(c.memory) && c.status != "halted" {
		opcode := c.memory[c.pointer]
		switch opcode {
		case 1:
			c.add()
		case 2:
			c.multiply()
		case 99:
			c.halt()
			return nil
		default:
			return fmt.Errorf("unknown opcode %v", opcode)
		}
	}
	return fmt.Errorf("pointer is out of memory bounds")
}

func (c *IntcodeComputer) add() {
	params := c.memory[c.pointer+1 : c.pointer+3+1]
	input1_pos := params[0]
	input2_pos := params[1]
	output_pos := params[2]
	c.memory[output_pos] = c.memory[input1_pos] + c.memory[input2_pos]
	c.pointer += 4
}

func (c *IntcodeComputer) multiply() {
	params := c.memory[c.pointer+1 : c.pointer+3+1]
	input1_pos := params[0]
	input2_pos := params[1]
	output_pos := params[2]
	c.memory[output_pos] = c.memory[input1_pos] * c.memory[input2_pos]
	c.pointer += 4
}

func (c *IntcodeComputer) halt() {
	c.status = "halted"
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
