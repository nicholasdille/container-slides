package main

import (
	"io"
	"os"
	"testing"
	"github.com/stretchr/testify/assert"
)

func captureOutput(f func()) string {
	orig := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w
	f()
	os.Stdout = orig
	w.Close()
	out, _ := io.ReadAll(r)
	return string(out)
}

func TestMain(t *testing.T) {
	output := captureOutput(func() {
		main()
	})
	assert.Equal(t, "by unknown, version none", output)
}
