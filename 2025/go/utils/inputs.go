package utils

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
)

func ReadInput() (input string, err error) {
	_, file, _, ok := runtime.Caller(1)
	if !ok {
		return "", errors.New("failed to get caller information. Can't determine which day to load")
	}

	day := filepath.Base(filepath.Dir(file))
	filePath := fmt.Sprintf("%s/../../inputs/%s-input.txt", filepath.Dir(file), day)
	content, err := os.ReadFile(filePath)
	if err != nil {
		return "", err
	}

	return string(bytes.TrimSpace(content)), nil
}

func ReadExampleInput() (input string, err error) {
	_, file, _, ok := runtime.Caller(1)
	if !ok {
		return "", errors.New("failed to get caller information. Can't determine which day to load")
	}

	day := filepath.Base(filepath.Dir(file))
	filePath := fmt.Sprintf("%s/../../inputs/%s-example-input.txt", filepath.Dir(file), day)
	content, err := os.ReadFile(filePath)
	if err != nil {
		return "", err
	}

	return string(bytes.TrimSpace(content)), nil
}
