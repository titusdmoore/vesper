package main

import "base:runtime"
import "cli"
import "core:bytes"
import "core:fmt"
import "core:mem"
import "network"

main :: proc() {
	// Because I have the memory of a goldfish, to run everything, odin run . -- test -i <remote-ip>
	cli.parse_args()
}
