package main

import "flag"
import "github.com/fatih/color"

var Author string = "unknown"
var Version string = "none"

func main() {
	var flagNoColor = flag.Bool("no-color", false, "Disable color output")
	flag.Parse()
	if *flagNoColor {
		color.NoColor = true
		color.Red("Disable colored output")
	}

	color.Green("hello world (by %s, version %s)", Author, Version)
}
