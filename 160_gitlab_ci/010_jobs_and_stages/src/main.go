package main

import "flag"
import "github.com/fatih/color"

func main() {
	var flagNoColor = flag.Bool("no-color", false, "Disable color output")
	flag.Parse()
	if *flagNoColor {
		color.NoColor = true
		color.Red("Disable colored output")
	}

	color.Green("hello world")
}
