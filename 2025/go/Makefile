DAY ?= $(shell date +%d)

default: test

test:
	go tool gotestsum ./day${DAY} -v

run:
	DAY=${DAY} go run .
