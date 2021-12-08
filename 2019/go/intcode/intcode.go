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

func (c *IntcodeComputer) Hack(address int, value int) error {
	if 0 <= address && address < len(c.memory) {
		c.memory[address] = value
		return nil
	} else {
		return fmt.Errorf("memory hack out of bounds ⛔️")
	}
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

func (c *IntcodeComputer) Read(address int) (int, error) {
	if 0 <= address && address < len(c.memory) {
		return c.memory[address], nil
	} else {
		return -1, fmt.Errorf("memory read out of bounds ⛔️")
	}
}

func (c *IntcodeComputer) add() {
	in1_address := c.memory[c.pointer+1]
	in2_address := c.memory[c.pointer+2]
	out_address := c.memory[c.pointer+3]
	c.memory[out_address] = c.memory[in1_address] + c.memory[in2_address]
	c.pointer += 4
}

func (c *IntcodeComputer) multiply() {
	in1_address := c.memory[c.pointer+1]
	in2_address := c.memory[c.pointer+2]
	out_address := c.memory[c.pointer+3]
	c.memory[out_address] = c.memory[in1_address] * c.memory[in2_address]
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
