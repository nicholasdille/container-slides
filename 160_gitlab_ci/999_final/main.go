package main

import (
	"fmt"

	"github.com/TwiN/go-color"
)

var Author string = "unknown"
var Version string = "none"

func main() {
	println(color.InGreen("hello world"))
	fmt.Printf("by %s, version %s", Author, Version)
}
