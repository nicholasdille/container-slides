package main

import "flag"
import "github.com/fatih/color"

func main() {
	var flagNoColor = flag.Bool("no-color", false, "Disable color output")
	flag.Parse()
	if *flagNoColor {
		color.Red("Disable colored output")
		color.NoColor = true
	}

	color.Green("hello world")
}