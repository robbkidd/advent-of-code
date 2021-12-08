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
