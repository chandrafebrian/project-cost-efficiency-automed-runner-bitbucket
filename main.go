package main

import (
	"automate-runner/fungsi"
)

func main() {

	go fungsi.CronAllJob()

	fungsi.StatusChecking()

}
