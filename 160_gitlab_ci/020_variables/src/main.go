package main

import fmt
import "github.com/TwiN/go-color"

func main() {
	println(color.InGreen("hello world"))
	fmt.Sprintf("by %s, version %s", Author, Version)
}