today=$$(date "+%d")
day=$(or ${DAY}, ${today})
new:
	@cp -R ./template/ ./day${day}/
	@sed -i '' "s/day__/day${day}/g" day${day}/main.go

test:
	@go test ./day${day}

run:
	@go run ./day${day}