package main

//3
import "flag"
//1
//import "fmt"

//2
import "github.com/fatih/color"

func main() {
	//1
	//fmt.Println("hello world")

	//3
	var flagNoColor = flag.Bool("no-color", false, "Disable color output")
	flag.Parse()
	if *flagNoColor {
		color.Red("Disable colored output")
		color.NoColor = true
	}

	//2
	color.Green("hello world")
}