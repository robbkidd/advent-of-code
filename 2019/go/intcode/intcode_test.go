package intcode

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestProgramToMemory(t *testing.T) {
	testCases := []struct {
		desc    string
		program string
		memory  []int
	}{
		{
			desc:    "example input",
			program: "1,9,10,3,2,3,11,0,99,30,40,50",
			memory:  []int{1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50},
		},
		{
			desc:    "1 + 1 = 2",
			program: "1,0,0,0,99",
			memory:  []int{1, 0, 0, 0, 99},
		},
		{
			desc:    "2 * 3",
			program: "2,3,0,3,99",
			memory:  []int{2, 3, 0, 3, 99},
		},
		{
			desc:    "99 * 99",
			program: "2,4,4,5,99,0",
			memory:  []int{2, 4, 4, 5, 99, 0},
		},
		{
			desc:    "99 * 99",
			program: "1,1,1,4,99,5,6,0,99",
			memory:  []int{1, 1, 1, 4, 99, 5, 6, 0, 99},
		},
	}
	for _, tC := range testCases {
		t.Run(tC.desc, func(t *testing.T) {
			assert.Equal(t,
				tC.memory,
				programToMemory(tC.program),
			)
		})
	}
}

func TestRun(t *testing.T) {
	cpu := new(IntcodeComputer)
	cpu.memory = []int{1, 1, 1, 4, 99, 5, 6, 0, 99}
	run_err := cpu.Run()
	assert.Nil(t, run_err)
	assert.Equal(t,
		[]int{30, 1, 1, 4, 2, 5, 6, 0, 99},
		cpu.memory,
	)
	assert.Equal(t,
		"halted",
		cpu.status,
	)
}

func TestLoadAndRun(t *testing.T) {
	cpu := new(IntcodeComputer)
	cpu.Load("1,1,1,4,99,5,6,0,99")
	run_err := cpu.Run()
	assert.Nil(t, run_err)
	assert.Equal(t,
		[]int{30, 1, 1, 4, 2, 5, 6, 0, 99},
		cpu.memory,
	)
	assert.Equal(t,
		"halted",
		cpu.status,
	)
}

func TestRead(t *testing.T) {
	cpu := IntcodeComputer{
		memory: []int{1, 0, 0, 0, 99},
	}
	assert.Equal(t, 5, len(cpu.memory))
	_, read_error := cpu.Read(5)
	assert.NotNil(t, read_error)
	read, read_error := cpu.Read(4)
	assert.Nil(t, read_error)
	assert.Equal(t, 99, read)

}

func TestAddition(t *testing.T) {
	cpu := new(IntcodeComputer)
	cpu.memory = []int{1, 0, 0, 0, 99}
	cpu.pointer = 0
	cpu.add()
	assert.Equal(t,
		[]int{2, 0, 0, 0, 99},
		cpu.memory,
	)
}

func TestMultiplication(t *testing.T) {
	cpu := new(IntcodeComputer)
	cpu.memory = []int{2, 3, 0, 3, 99}
	cpu.pointer = 0
	cpu.multiply()
	assert.Equal(t,
		[]int{2, 3, 0, 6, 99},
		cpu.memory,
	)
}

func TestHack(t *testing.T) {
	cpu := IntcodeComputer{
		memory: []int{2, 3, 0, 3, 99},
	}
	cpu.Hack(2, 42)
	assert.Equal(t,
		[]int{2, 3, 42, 3, 99},
		cpu.memory,
	)
}

func TestExamples(t *testing.T) {
	testCases := []struct {
		desc       string
		program    string
		finalState []int
	}{
		{
			desc:       "example input",
			program:    "1,9,10,3,2,3,11,0,99,30,40,50",
			finalState: []int{3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50},
		},
		{
			desc:       "1 + 1 = 2",
			program:    "1,0,0,0,99",
			finalState: []int{2, 0, 0, 0, 99},
		},
		{
			desc:       "2 * 3",
			program:    "2,3,0,3,99",
			finalState: []int{2, 3, 0, 6, 99},
		},
		{
			desc:       "99 * 99",
			program:    "2,4,4,5,99,0",
			finalState: []int{2, 4, 4, 5, 99, 9801},
		},
		{
			desc:       "99 * 99",
			program:    "1,1,1,4,99,5,6,0,99",
			finalState: []int{30, 1, 1, 4, 2, 5, 6, 0, 99},
		},
	}
	for _, tC := range testCases {
		t.Run(tC.desc, func(t *testing.T) {
			cpu := new(IntcodeComputer)
			cpu.Load(tC.program)
			cpu.Run()
			assert.Equal(t,
				tC.finalState,
				cpu.memory,
			)
		})
	}
}
