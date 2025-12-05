package main

import (
	"testing"
)

func TestEcho(t *testing.T) {
	// Test happy path
	err := echo([]string{"bin-name", "hello", "world!"})
	if err != nil {
		t.Errorf("Failed to generate output")
	}
}

func TestEchoErrorNoArgs(t *testing.T) {
	// Test empty arguments
	err := echo([]string{})
	if err == nil {
		t.Errorf("Should have failed without arguments")
	}
}